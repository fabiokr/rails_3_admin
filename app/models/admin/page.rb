module Admin
  class Page < ActiveRecord::Base
    extend ActiveSupport::Memoizable
    include Admin::Models::SeoEnable

    has_many :page_contents, :dependent => :destroy

    attr_accessible :page_contents_attributes
    accepts_nested_attributes_for :page_contents

    validates :controller_path, :presence => true

    scope :sorted, (lambda do |*args|
      sort = args.first
      order(sort.nil? ? 'title asc' : sort)
    end)

    scope :available, lambda { where(:controller_path => valid_controllers) }

    scope :localized, lambda { |locale| where(:locale => locale) }

    class << self

      # Looks for the page related to a controller.
      def for_controller(controller_path)
        finder = lambda { where(:controller_path => controller_path).localized(I18n.locale).first }

        unless page = finder.call
          generate!
          page = finder.call
        end

        page
      end

      # Retrieves a list of controller which will have managable content.
      # This will ignore controllers within a namespace starting with the
      # configured ApplicationController.managable_content_ignore_namespace
      # and also the ActiveAdmin.config.default_namespace.
      def generate!
        controllers = (Rails.application.routes.routes.map do |route|
          controller_name = "#{route.requirements[:controller].camelize}Controller"
          ActiveSupport::Dependencies.ref(controller_name).get
        end).insert(0, ApplicationController).uniq

        valid_controllers = valid_controllers()

        controllers.each do |controller|
          controller_path = controller.controller_path
          if controller.respond_to?(:managable_content_for) && valid_controllers.include?(controller_path)
            Page.transaction do
              (Rails.configuration.available_locales || [Rails.configuration.i18n.locale]).each do |locale|
                # Create Page if it does not exist yet
                page = Page.where(:controller_path => controller_path, :locale => locale).first || Page.new()
                if page.new_record?
                  page.controller_path = controller_path
                  page.locale = locale
                  page.save!
                end

                # Create PageContent if it does not exist yet
                contents = (controller == ApplicationController) ? controller.managable_layout_content_for : controller.managable_content_for
                contents.each do |key|
                  if page.page_contents.where(:key => key).first.nil?
                    page_content = page.page_contents.build
                    page_content.key = key
                    page_content.save!
                  end
                end
              end
            end
          end
        end
      end

      def valid_controllers
        controller_paths = Rails.application.routes.routes.map do |route|
          controller_path = route.requirements[:controller]
        end

        ignored_namespaces = ApplicationController.managable_content_ignore_namespace
        ignored_namespaces << 'rails'

        valid_controllers = controller_paths.uniq.select do |controller_path|
          !controller_path.empty? && !ignored_namespaces.detect do |ignored|
            controller_path.start_with?(ignored)
          end
        end

        valid_controllers.insert(0, ApplicationController.controller_path).uniq
      end
    end

    def url
      route, url = Rails.application.routes.routes.find { |route| route.requirements[:controller] == controller_path}, nil

      if route
        generate_route = lambda { |action| Rails.application.routes.generate(:controller => route.requirements[:controller], :action => action) }

        #first try with index
        begin
          url = generate_route.call(:index)
        rescue ActionController::RoutingError
        end

        #if didn't exist, try with show
        begin
          url = generate_route.call(:show) if url.nil?
        rescue ActionController::RoutingError
        end
      end

      url
    end
    memoize :url

  end
end
