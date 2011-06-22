require 'test_helper'

class PagesController < ApplicationController
end

class FirstMocksController < ApplicationController
end

class SecondMocksController < ApplicationController
end

class ThirdMocksController < ApplicationController
end

class FourthMocksController < ApplicationController
end

class FifthMocksController < ApplicationController
end

class SixthMocksController < ApplicationController
end

class PagesDashboardPanelCellTest < Cell::TestCase

  def setup
    super
    Rails.application.routes.draw do
      namespace 'admin' do
        resources :pages
      end

      resources :first_mocks
      resources :second_mocks
      resources :third_mocks
      resources :fourth_mocks
      resources :fifth_mocks
      resources :sixth_mocks
    end

    Admin::Page.generate!
  end

  def teardown
    Rails.application.reload_routes!
  end

  test "display" do
    invoke :display

    Admin::Page.available.sorted('updated_at DESC').limit(5).each do |page|
      assert_select 'td', page.title
    end
  end
end
