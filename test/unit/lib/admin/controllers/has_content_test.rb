require 'test_helper'

class Admin::HasContentMock < ApplicationController
  include Admin::Controllers::HasContent

  managable_content_ignore_namespace 'another'
  managable_layout_content_for :header
  managable_content_for :body, :side
end

class Admin::HasContentTest < ActiveSupport::TestCase

  def setup
    @application_controller = ApplicationController.new
    @controller = Admin::HasContentMock.new

    @application_page = Factory(:page, :controller_path => @application_controller.controller_path)
    @content_header = Factory(:page_content, :page => @application_page, :key => 'header')
    @application_page.reload

    @page = Factory(:page, :controller_path => @controller.controller_path)
    @content_body = Factory(:page_content, :page => @page, :key => 'body')
    @content_side = Factory(:page_content, :page => @page, :key => 'side')
    @page.reload
  end

  test 'should configure content types' do
    assert_equal [:body, :side], Admin::HasContentMock.managable_content_for
  end

  test 'should configure ignored namespace' do
    assert Admin::HasContentMock.managable_content_ignore_namespace.include?('another')
  end

  test 'should configure managable layout content for' do
    assert Admin::HasContentMock.managable_layout_content_for.include?(:header)
  end

  test 'should retrieve correct page content with helper' do
    assert_equal @page.title, @controller.managable_content_for(:title)
    assert_equal @page.description, @controller.managable_content_for(:description)
    assert_equal @page.keywords, @controller.managable_content_for(:keywords)
    assert_equal @page.updated_at, @controller.managable_content_for(:updated_at)
  end

  test 'should retrieve nil for non existent page' do
    @page.destroy
    assert_nil @controller.managable_content_for(:title)
  end

  test 'should retrieve correct content with helper' do
    assert_equal @content_body.content, @controller.managable_content_for(:body)
    assert_equal @content_side.content, @controller.managable_content_for(:side)

    assert_equal @content_header.content, @controller.managable_layout_content_for(:header)
  end

  test 'should retrieve nil for invalid content' do
    assert_nil @controller.managable_content_for(:invalid)
  end
end
