ActiveAdmin.register Page do

  actions :index, :show, :edit, :update

  filter :title
  filter :description
  filter :tags

  before_filter do
    Page.generate!
  end

  scope :available, :default => true

  index do
    column :url do |page|
      link_to_if (url = page.url), url, url
    end
    column :title
    column :updated_at, :sortable => :updated_at do |page|
      l page.updated_at, :format => :short
    end
    column '' do |page|
      links = []
      links << link_to(I18n.t('active_admin.view'), resource_path(page), :class => "view_link")
      links << link_to(I18n.t('active_admin.edit'), edit_resource_path(page), :class => "edit_link")
      links.join(' ').html_safe
    end
  end

  show do |page|
    attributes = page.class.columns.collect{|column| column.name.to_sym } - [:controller_path] + [:url]
    attributes_table *attributes do
      table do
        page.page_contents.each do |content|
          tr do
            th do
              I18n.t("active_admin_pages.#{content.key}")
            end
            td do
              content.content.html_safe unless content.content.nil?
            end
          end
        end
      end
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

    #only shows page_contents if the page has managable contents
    if !f.object.page_contents.empty? && f.object.page_contents.detect{|content| controller.managable_content_for.include? content.key.to_sym}
      f.inputs "Content" do
        f.fields_for :page_contents do |content|
          if controller.managable_content_for.include? content.object.key.to_sym
            content.inputs do
              content.input :id, :as => :hidden
              content.input :content, :label => I18n.t("active_admin_pages.#{content.object.key}"), :input_html => {:class => 'wysiwyg'}
            end
          end
        end
      end
    end

    f.buttons
  end

  sidebar :help, :only => [:new, :create, :edit, :update]  do
    ul do
      li I18n.t('active_admin_pages.help_title')
      li I18n.t('active_admin_pages.help_description')
      li I18n.t('active_admin_pages.help_tags')
    end
  end
end
