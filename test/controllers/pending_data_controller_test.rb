require 'test_helper'

class PendingDataControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get pending_data_new_url
    assert_response :success
  end

  test "should get create" do
    get pending_data_create_url
    assert_response :success
  end

end
