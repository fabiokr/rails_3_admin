require 'test_helper'

class HomeMocksController < ApplicationController
  managable_content_for :body, :side
end

class OtherMocksController < ApplicationController
  managable_content_for :body, :footer
end

class HomeNoContentMocksController < ApplicationController
end

class PageTest < ActiveSupport::TestCase

  should have_db_column(:controller_path).of_type(:string)
  should have_db_column(:title).of_type(:string)
  should have_db_column(:description).of_type(:string)
  should have_db_column(:tags).of_type(:string)

  should have_db_index(:controller_path).unique(true)

  should_not allow_mass_assignment_of(:controller_path)
  should_not allow_mass_assignment_of(:updated_at)
  should_not allow_mass_assignment_of(:created_at)

  should allow_mass_assignment_of(:title)
  should allow_mass_assignment_of(:description)
  should allow_mass_assignment_of(:tags)
  should allow_mass_assignment_of(:page_contents_attributes)

  should validate_presence_of(:controller_path)

  should have_many(:page_contents).dependent(:destroy)

  test 'should be able to find page content' do
    @page = Factory(:page, :controller_path => 'controller_path')
    @content_body = Factory(:page_content, :page => @page, :key => 'body')
    @content_side = Factory(:page_content, :page => @page, :key => 'side')

    assert_equal @content_body, Page.content(@page.controller_path, @content_body.key)
    assert_equal @content_side, Page.content(@page.controller_path, @content_side.key)
  end

  test 'should be able to generate pages for existing controllers' do
    Rails.application.routes.draw do
      resources :home_mocks
      resources :other_mocks
      resources :home_no_content_mocks
    end

    Page.generate!
    check_generated_pages

    # Should NOT regenarete already existing pages and contents
    Page.generate!
    check_generated_pages

    Rails.application.reload_routes!
  end

  private

  def check_generated_pages
    @pages = Page.all
    assert_equal 2, @pages.size

    @page = @pages[0]
    assert_equal HomeMocksController.controller_path, @page.controller_path

    assert_equal 2, @page.page_contents.size
    assert_equal 'body', @page.page_contents[0].key
    assert_equal 'side', @page.page_contents[1].key

    @page = @pages[1]
    assert_equal OtherMocksController.controller_path, @page.controller_path

    assert_equal 2, @page.page_contents.size
    assert_equal 'body', @page.page_contents[0].key
    assert_equal 'footer', @page.page_contents[1].key
  end

end
