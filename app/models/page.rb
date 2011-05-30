class Page < ActiveRecord::Base
  has_many :page_contents, :dependent => :destroy

  attr_accessible :title, :description, :tags, :page_contents_attributes
  accepts_nested_attributes_for :page_contents

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
          page = Page.where(:controller_path => controller_path).first || Page.new()
          if page.new_record?
            page.controller_path = controller_path
            page.save!
          end

          # Create PageContent if it does not exist yet
          controller.managable_content_for.each do |key|
            if content(controller_path, key).nil?
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
