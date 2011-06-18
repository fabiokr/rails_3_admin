class ApplicationController < ActionController::Base
  include Admin::Controllers::HasContent

  protect_from_forgery
  layout :layout

  managable_content_ignore_namespace 'admin', 'devise', 'ckeditor', 'jammit', 'errors'

  respond_to :html

  protected

  def layout
    devise_controller? ? 'login' : 'application'
  end
end
