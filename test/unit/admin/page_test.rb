require 'test_helper'

class ApplicationController
  managable_content_ignore_namespace 'ignored'
  managable_layout_content_for :header
end

class HomeMocksController < ApplicationController
  managable_content_for :body, :side
end

class OtherMocksController < ApplicationController
  managable_content_for :body, :footer
end

class HomeNoContentMocksController < ApplicationController
end

class IgnoredMocksController < ApplicationController
end

module Admin
  class PageTest < ActiveSupport::TestCase
    include Admin::Models::SeoEnableTest

    should have_db_column(:controller_path).of_type(:string)

    should have_db_index(:controller_path).unique(true)

    should_not allow_mass_assignment_of(:controller_path)
    should_not allow_mass_assignment_of(:updated_at)
    should_not allow_mass_assignment_of(:created_at)
    should allow_mass_assignment_of(:page_contents_attributes)

    should validate_presence_of(:controller_path)

    should have_many(:page_contents).dependent(:destroy)

    def setup
      Rails.application.routes.draw do
        resources :home_mocks
        resources :other_mocks
        resources :home_no_content_mocks
        resources :ignored_mocks
      end
    end

    def teardown
      Rails.application.reload_routes!
    end

    test 'should be able to find page' do
      @page = Factory(:page)

      assert_equal @page.id, Page.for_controller(@page.controller_path).id
    end

    test 'should be able to find a page that was not yet created' do
      assert_equal 'home_mocks', Page.for_controller('home_mocks').controller_path
    end

    test 'should be able to generate pages for existing controllers' do
      Page.generate!
      check_generated_pages

      # Should NOT regenarete already existing pages and contents
      Page.generate!
      check_generated_pages
    end

    test 'should be able to get the page url' do
      Page.generate!

      @page = Page.for_controller(HomeMocksController.controller_path)
      assert_equal '/home_mocks', @page.url
    end

    test 'should have available scope' do
      assert_equal Page.where(:controller_path => Page.valid_controllers), Page.available
    end

    test 'should have sorted scope' do
      assert_equal Page.order('title ASC').all, Page.sorted.all
    end

    private

    def check_generated_pages
      @pages = Page.all
      assert_equal 4, @pages.size

      #should generate global content for header as defined on managable_layout_content_for
      @page = @pages[0]
      assert_equal ApplicationController.controller_path, @page.controller_path

      assert_equal 1, @page.page_contents.size
      assert_equal 'header', @page.page_contents[0].key

      @page = @pages[1]
      assert_equal HomeMocksController.controller_path, @page.controller_path

      assert_equal 2, @page.page_contents.size
      assert_equal 'body', @page.page_contents[0].key
      assert_equal 'side', @page.page_contents[1].key

      @page = @pages[2]
      assert_equal OtherMocksController.controller_path, @page.controller_path

      assert_equal 2, @page.page_contents.size
      assert_equal 'body', @page.page_contents[0].key
      assert_equal 'footer', @page.page_contents[1].key

      @page = @pages[3]
      assert_equal HomeNoContentMocksController.controller_path, @page.controller_path

      assert @page.page_contents.empty?
    end

  end
end
