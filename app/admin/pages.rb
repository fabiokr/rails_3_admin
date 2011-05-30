ActiveAdmin.register Page do

  actions :index, :show, :edit, :update

  filter :title
  filter :description
  filter :tags

  before_filter do
    Page.generate!
  end

  scope :available, :default => true do |pages|
    pages.where(:controller_path => Page.valid_controllers)
  end

  index do
    column :url do |page|
      route = Rails.application.routes.routes.find { |route| route.requirements[:controller] == page.controller_path}

      #first try with index
      begin
        url = Rails.application.routes.generate(:controller => route.requirements[:controller], :action => :index)
      rescue ActionController::RoutingError
      end

      #if didn't exist, try with show
      begin
        url = Rails.application.routes.generate(:controller => route.requirements[:controller], :action => :show) if url.nil?
      rescue ActionController::RoutingError
      end

      link_to_if !url.nil?, url, url
    end
    column :title
    column :description
    column :tags
    column :updated_at
    column '' do |page|
      links = link_to I18n.t('active_admin.view'), resource_path(page), :class => "view_link"
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(page), :class => "edit_link"
    end
  end

  form do |f|
    controller_name = "#{f.object.controller_path.camelize}Controller"
    controller = ActiveSupport::Dependencies.ref(controller_name).get

    f.inputs "Details" do
      f.input :title
      f.input :description
      f.input :tags
    end
    f.inputs "Content" do
      f.fields_for :page_contents do |content|
        if controller.managable_content_for.include? content.object.key.to_sym
          content.inputs do
            content.input :id, :as => :hidden
            content.input :content, :label => I18n.t("pages.#{content.object.key}"), :input_html => {:class => 'wysiwyg'}
          end
        end
      end
    end
    f.buttons
  end
end
