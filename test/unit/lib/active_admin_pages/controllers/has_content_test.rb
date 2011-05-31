require 'test_helper'

class ActiveAdminPages::HasContentMock < ApplicationController
  include ActiveAdminPages::Controllers::HasContent

  managable_content_ignore_namespace 'another'
  managable_content_for :body, :side
end

class ActiveAdminPages::HasContentTest < ActiveSupport::TestCase

  def setup
    @controller = ActiveAdminPages::HasContentMock.new

    @page = Factory(:page, :controller_path => @controller.controller_path)
    @content_body = Factory(:page_content, :page => @page, :key => 'body')
    @content_side = Factory(:page_content, :page => @page, :key => 'side')
  end

  test 'should configure content types' do
    assert_equal [:body, :side], ActiveAdminPages::HasContentMock.managable_content_for
  end

  test 'should configure ignored namespace' do
    assert ActiveAdminPages::HasContentMock.managable_content_ignore_namespace.include?('another')
  end

  test 'should retrieve correct content with helper' do
    assert_equal @content_body.content, @controller.managable_content_for(:body)
    assert_equal @content_side.content, @controller.managable_content_for(:side)
  end

  test 'should retrieve correct page content with helper' do
    assert_equal @page.title, @controller.managable_content_for(:title)
    assert_equal @page.description, @controller.managable_content_for(:description)
    assert_equal @page.tags, @controller.managable_content_for(:tags)
  end

  test 'should retrieve nil for invalid content' do
    assert_nil @controller.managable_content_for(:invalid)
  end
end
