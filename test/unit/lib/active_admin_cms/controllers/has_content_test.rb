require 'test_helper'

class ActiveAdminCms::HasContentMock < ApplicationController
  include ActiveAdminCms::Controllers::HasContent

  managable_content_ignore_namespace 'admin', 'another'
  managable_content_for :body, :side
end

class ActiveAdminCms::HasContentTest < ActiveSupport::TestCase

  def setup
    @controller = ActiveAdminCms::HasContentMock.new

    @page = Factory(:page, :controller_path => @controller.controller_path)
    @content_body = Factory(:page_content, :page => @page, :key => 'body')
    @content_side = Factory(:page_content, :page => @page, :key => 'side')
  end

  test 'should configure content types' do
    assert_equal [:body, :side], ActiveAdminCms::HasContentMock.managable_content_for
  end

  test 'should configure ignored namespace' do
    assert_equal ['admin', 'another'], ActiveAdminCms::HasContentMock.managable_content_ignore_namespace
  end

  test 'should retrieve correct content with helper' do
    assert_equal @content_body.content, @controller.managable_content_for(:body)
    assert_equal @content_side.content, @controller.managable_content_for(:side)
  end

  test 'should retrieve nil for invalid content' do
    assert_nil @controller.managable_content_for(:invalid)
  end
end
