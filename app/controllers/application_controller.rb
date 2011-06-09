class ApplicationController < ActionController::Base
  include Admin::Controllers::HasContent

  protect_from_forgery
  layout :layout
  managable_content_ignore_namespace 'devise', 'ckeditor'

  protected

  def layout
    devise_controller? ? 'login' : 'application'
  end
end
