require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:michael)
  end
  
  # 編集の失敗
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name: "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" } }
    assert_template "users/edit"                                          
  end
  
  # 編集の成功(フレンドリーフォワーディング)
  test "successful edit with frendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    patch user_path(@user), params: { user: { name: "Mike",
                                              email: "mike@mike.com",
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal "Mike", @user.name
    assert_equal "mike@mike.com", @user.email
  end
end
