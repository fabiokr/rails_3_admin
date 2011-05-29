class Page < ActiveRecord::Base
  has_many :page_contents, :dependent => :destroy

  validates :controller_path, :presence => true

  # Looks for a PageContent by the controller path and the content key
  def self.content(controller_path, key)
    PageContent.joins(:page)
               .where(:key => key, :pages => {:controller_path => controller_path})
               .first
  end

  # Generates Pages for each Controller that has managable_content_for set
  def self.generate!
    controllers = Rails.application.routes.routes.map do |route|
      controller_name = "#{route.requirements[:controller].camelize}Controller"
      ActiveSupport::Dependencies.ref(controller_name).get
    end

    controllers.uniq.each do |controller|
      controller_path = controller.controller_path
      if controller.respond_to?(:managable_content_for) && !controller.managable_content_for.empty?
        Page.transaction do
          # Create Page if it does not exist yet
          page = Page.where(:controller_path => controller_path).first || Page.new(:controller_path => controller_path)
          page.save! if page.new_record?

          # Create PageContent if it does not exist yet
          controller.managable_content_for.each do |key|
            page.page_contents.create(:key => key) if content(controller_path, key).nil?
          end
        end
      end
    end
  end
end
