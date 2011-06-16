require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  should have_db_column(:email).of_type(:string)
  should have_db_column(:encrypted_password).of_type(:string)
  should have_db_column(:reset_password_token).of_type(:string)
  should have_db_column(:reset_password_sent_at).of_type(:datetime)
  should have_db_column(:remember_created_at).of_type(:datetime)
  should have_db_column(:sign_in_count).of_type(:integer)
  should have_db_column(:current_sign_in_at).of_type(:datetime)
  should have_db_column(:last_sign_in_at).of_type(:datetime)
  should have_db_column(:current_sign_in_ip).of_type(:string)
  should have_db_column(:last_sign_in_ip).of_type(:string)

  should have_db_index(:email).unique(true)
  should have_db_index(:reset_password_token).unique(true)

  should validate_presence_of(:email)

  test 'should have sorted scope' do
    members = [Factory(:admin_user), Factory(:admin_user)]

    assert_equal AdminUser.order('email ASC'), AdminUser.sorted
  end
end
