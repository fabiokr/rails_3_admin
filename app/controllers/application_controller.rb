class ApplicationController < ActionController::Base
  include Admin::Controllers::HasContent

  managable_content_ignore_namespace 'devise', 'ckeditor'
  protect_from_forgery
  layout :layout

  protected

  def layout
    devise_controller? ? 'login' : 'application'
  end
end
