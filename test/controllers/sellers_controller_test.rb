require 'test_helper'

class SellersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seller = sellers(:one)
  end

  test "should get index" do
    get sellers_url
    assert_response :success
  end

  test "should get new" do
    get new_seller_url
    assert_response :success
  end

  test "should create seller" do
    assert_difference('Seller.count') do
      post sellers_url, params: { seller: { confirm_token: @seller.confirm_token, email: @seller.email, email_confirmed: @seller.email_confirmed, group_id: @seller.group_id, name: @seller.name, num_in_institution: @seller.num_in_institution, num_of_logins: @seller.num_of_logins, password: 'secret', password_confirmation: 'secret', phone_number: @seller.phone_number, rut: @seller.rut } }
    end

    assert_redirected_to seller_url(Seller.last)
  end

  test "should show seller" do
    get seller_url(@seller)
    assert_response :success
  end

  test "should get edit" do
    get edit_seller_url(@seller)
    assert_response :success
  end

  test "should update seller" do
    patch seller_url(@seller), params: { seller: { confirm_token: @seller.confirm_token, email: @seller.email, email_confirmed: @seller.email_confirmed, group_id: @seller.group_id, name: @seller.name, num_in_institution: @seller.num_in_institution, num_of_logins: @seller.num_of_logins, password: 'secret', password_confirmation: 'secret', phone_number: @seller.phone_number, rut: @seller.rut } }
    assert_redirected_to seller_url(@seller)
  end

  test "should destroy seller" do
    assert_difference('Seller.count', -1) do
      delete seller_url(@seller)
    end

    assert_redirected_to sellers_url
  end
end
