module Admin
  class PagesController < Admin::Controllers::Resource
    before_filter do
      Page.generate!
    end
  end
end
