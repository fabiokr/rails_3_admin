Rails.application.config.admin_menu = Admin::Menu.configure do
  #Pages
  menu Admin::Page, :plural => true do
    item :admin_pages_path, :title => proc { I18n.t("admin.index_resource", :resource_name => Admin::Page.model_name.human.pluralize) }, :icon => 'edit_article'
  end

  #Custom

  #Users
  menu AdminUser do
    item :new_admin_user_path, :title => proc { I18n.t("admin.new_resource", :resource_name => AdminUser.model_name.human) }, :icon => 'add_user'
    item :admin_users_path, :title => proc { I18n.t("admin.index_resource", :resource_name => AdminUser.model_name.human.pluralize) }, :icon => 'view_users'
  end
end
