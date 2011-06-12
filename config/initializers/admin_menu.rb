Rails.application.config.admin_menu = Admin::Menu.configure do
  #Pages
  menu Admin::Page, :plural => true do
    item :admin_pages_path, :title => proc { I18n.t("admin.index_resource", :resource_name => Admin::Page.model_name.human.pluralize) }, :icon => 'edit_article'
  end

  #Custom

  #System
  menu proc{ I18n.t('admin.admin') } do
    item :destroy_admin_user_session_path, :title => proc{ I18n.t('admin.sign_out') }, :icon => 'jump_back'
  end
end
