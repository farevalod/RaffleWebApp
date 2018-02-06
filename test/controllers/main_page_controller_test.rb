require 'test_helper'

class MainPageControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get main_page_show_url
    assert_response :success
  end

end
