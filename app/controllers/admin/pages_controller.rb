module Admin
  class PagesController < Admin::Controllers::Resource
    actions :all, :except => [ :new, :create, :delete, :destroy ]

    before_filter do
      Page.generate!
    end
  end
end
