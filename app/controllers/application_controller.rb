class ApplicationController < ActionController::Base
  include ActiveAdminPages::Controllers::HasContent

  managable_content_ignore_namespace 'ckeditor'
  protect_from_forgery
end
