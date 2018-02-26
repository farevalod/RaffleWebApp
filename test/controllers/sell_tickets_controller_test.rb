require 'test_helper'

class SellTicketsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get sell_tickets_create_url
    assert_response :success
  end

end
