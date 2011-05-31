class Page < ActiveRecord::Base
  has_many :page_contents, :dependent => :destroy

  attr_accessible :title, :description, :tags, :page_contents_attributes
  accepts_nested_attributes_for :page_contents

  validates :controller_path, :presence => true

  class << self

    def for_controller(controller_path)
      where(:controller_path => controller_path).first
    end

    # Retrieves a list of controller which will have managable content.
    # This will ignore controllers within a namespace starting with the
    # configured ApplicationController.managable_content_ignore_namespace
    # and also the ActiveAdmin.config.default_namespace.
    def generate!
      controllers = Rails.application.routes.routes.map do |route|
        controller_name = "#{route.requirements[:controller].camelize}Controller"
        ActiveSupport::Dependencies.ref(controller_name).get
      end

      valid_controllers = valid_controllers()

      controllers.uniq.each do |controller|
        controller_path = controller.controller_path
        if controller.respond_to?(:managable_content_for) && valid_controllers.include?(controller_path)
          Page.transaction do
            # Create Page if it does not exist yet
            page = Page.where(:controller_path => controller_path).first || Page.new()
            if page.new_record?
              page.controller_path = controller_path
              page.save!
            end

            # Create PageContent if it does not exist yet
            controller.managable_content_for.each do |key|
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

    def valid_controllers
      valid_controllers = []
      if valid_controllers.empty?
        controller_paths = Rails.application.routes.routes.map do |route|
          controller_path = route.requirements[:controller]
        end

        ignored_namespaces = ApplicationController.managable_content_ignore_namespace
        ignored_namespaces << ActiveAdmin::Configuration.default_namespace.to_s

        valid_controllers = controller_paths.uniq.select do |controller_path|
          !ignored_namespaces.detect do |ignored|
            controller_path.start_with?(ignored)
          end
        end

        valid_controllers.uniq!
      end

      valid_controllers
    end
  end
end
