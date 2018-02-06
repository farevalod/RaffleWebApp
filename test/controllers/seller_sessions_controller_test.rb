require 'test_helper'

class SellerSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get seller_sessions_new_url
    assert_response :success
  end

  test "should get create" do
    get seller_sessions_create_url
    assert_response :success
  end

  test "should get destroy" do
    get seller_sessions_destroy_url
    assert_response :success
  end

end
