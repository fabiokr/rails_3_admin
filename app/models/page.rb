class Page < ActiveRecord::Base
  has_many :page_contents, :dependent => :destroy

  validates :controller_path, :presence => true

  def self.content(controller_path, key)
    PageContent.joins(:page)
               .where(:key => key, :pages => {:controller_path => controller_path})
               .first
  end

  def self.contentable_controllers
    controllers = Rails.application.routes.routes.map do |route|
      controller_param = route.requirements[:controller]
      controller_name = "#{controller_param.camelize}Controller"

      ActiveSupport::Dependencies.ref(controller_name).get
    end
    controllers.uniq.each {|c| puts c.test if c.respond_to?(:test)}
  end
end
