require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:one)
  end

  test "should get index" do
    get admins_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_url
    assert_response :success
  end

  test "should create admin" do
    assert_difference('Admin.count') do
      post admins_url, params: { admin: { admin_level: @admin.admin_level, confirm_token: @admin.confirm_token, email: @admin.email, email_confirmed: @admin.email_confirmed, institution_id: @admin.institution_id, name: @admin.name, password: 'secret', password_confirmation: 'secret', phone_number: @admin.phone_number, user_name: @admin.user_name } }
    end

    assert_redirected_to admin_url(Admin.last)
  end

  test "should show admin" do
    get admin_url(@admin)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_url(@admin)
    assert_response :success
  end

  test "should update admin" do
    patch admin_url(@admin), params: { admin: { admin_level: @admin.admin_level, confirm_token: @admin.confirm_token, email: @admin.email, email_confirmed: @admin.email_confirmed, institution_id: @admin.institution_id, name: @admin.name, password: 'secret', password_confirmation: 'secret', phone_number: @admin.phone_number, user_name: @admin.user_name } }
    assert_redirected_to admin_url(@admin)
  end

  test "should destroy admin" do
    assert_difference('Admin.count', -1) do
      delete admin_url(@admin)
    end

    assert_redirected_to admins_url
  end
end
