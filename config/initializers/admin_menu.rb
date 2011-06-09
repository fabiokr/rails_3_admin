Rails.application.config.admin_menu = Admin::Menu.configure do
  #Pages
  menu proc{ Admin::Page.model_name.human.pluralize } do
    entry proc{ I18n.t('admin.index_resource', :resource_name => Admin::Page.model_name.human.pluralize) }, :admin_pages_path, :icon => 'edit_article'
  end

  #Custom

  #System
  menu proc{ I18n.t('admin.admin') } do
    entry proc{ I18n.t('admin.sign_out') }, :destroy_admin_user_session_path, :icon => 'jump_back'
  end
end
