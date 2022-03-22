require 'test_helper'

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: "johndoe", email: "johndoe@example.com", password: "password", admin: true)
  end

  test "get new category form and create category" do
    sign_in_as(@admin_user)
    get "/categories/new"
    assert_response :success

    assert_difference('Category.count') do
      post categories_url, params: { category: { name: "Travel" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Travel", response.body
  end

  test "get new category form and reject invalid category submission" do
    sign_in_as(@admin_user)
    get "/categories/new"
    assert_response :success

    assert_no_difference 'Category.count' do
      post categories_url, params: { category: { name: "" } }      
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
