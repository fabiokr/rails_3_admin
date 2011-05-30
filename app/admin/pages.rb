ActiveAdmin.register Page do

  actions :index, :show, :edit, :update

  filter :title
  filter :description
  filter :tags

  before_filter :only => :index do
    Page.generate!
  end

  index do
    column :url do |page|
      link_to page.controller_path, admin_page_path(page)
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
    f.inputs "Details" do
      f.input :title
      f.input :description
      f.input :tags
    end
    f.inputs "Content" do
      f.inputs :for => :page_contents do |content|
        content.input :id, :as => :hidden
        content.input :content, :label => I18n.t("pages.#{content.object.key}")
      end


      #f.object.page_contents.each do |content|
      #  f.input "content_#{content.key}"
      #end
    end
    f.buttons
  end
end
