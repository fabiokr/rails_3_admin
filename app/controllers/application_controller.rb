class ApplicationController < ActionController::Base
  include ActiveAdminCms::Controllers::HasContent

  protect_from_forgery
end
