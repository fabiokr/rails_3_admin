require 'test_helper'

class PageTest < ActiveSupport::TestCase

  should have_db_column(:controller_path).of_type(:string)
  should have_db_column(:title).of_type(:string)
  should have_db_column(:description).of_type(:string)
  should have_db_column(:tags).of_type(:string)

  should have_db_index(:controller_path).unique(true)

  should validate_presence_of(:controller_path)

  should have_many(:page_contents).dependent(:destroy)

  def setup
    @page = Factory(:page, :controller_path => 'controller_path')
    @content_body = Factory(:page_content, :page => @page, :key => 'body')
    @content_side = Factory(:page_content, :page => @page, :key => 'side')
  end

  test 'should be able to find page content' do
    assert_equal @content_body, Page.content(@page.controller_path, @content_body.key)
    assert_equal @content_side, Page.content(@page.controller_path, @content_side.key)
  end

end
