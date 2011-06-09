require 'test_helper'

module Admin
  class PageContentTest < ActiveSupport::TestCase

    should have_db_column(:page_id).of_type(:integer)
    should have_db_column(:key).of_type(:string)
    should have_db_column(:content).of_type(:text)

    should have_db_index(:page_id)
    should have_db_index([:page_id, :key]).unique(true)

    should_not allow_mass_assignment_of(:page_id)
    should_not allow_mass_assignment_of(:key)
    should_not allow_mass_assignment_of(:updated_at)
    should_not allow_mass_assignment_of(:created_at)

    should allow_mass_assignment_of(:content)

    should validate_presence_of(:page_id)
    should validate_presence_of(:key)

    should belong_to :page

    test 'should be able to find by key' do
      @page_content = Factory(:page_content)

      assert_equal @page_content, PageContent.for_key(@page_content.key).first
    end

  end
end
