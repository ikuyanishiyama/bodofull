require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end
  
  test "password resets" do
    get new_password_reset_path
    assert_template "password_resets/new"
  # メールアドレスの入力パージで、メアドが無効（該当するアカウントがない）
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template "password_resets/new"
  # メールアドレスの入力パージで、メアドが有効
    post password_resets_path, params: { password_reset: { email: @user.email } }
    # DBに保存するreset_digestが新しく更新されているか確認
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # 再設定用のメールが1通送られているか確認
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  
  # パスワード再設定のフォームのテスト
    user = assigns(:user)
  # editに入る時にurlの中のメールアドレスが無効
    get edit_password_reset_path(user.reset_token, email = "")
    assert_redirected_to root_url
  # メールアドレスが有効でトークンが有効期限切れ(もしくは正しくないトークン)
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url
  # メールアドレスもトークンも有効
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email
  
  # 無効なパスワードとパスワード確認が送られた場合
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: "foo",
                            password_confirmation: "bar" } }
    assert_select "div#error_explanation"
  # パスワードが空
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: "",
                            password_confirmation: "" } }
    assert_select "div#error_explanation"
  # 有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: "password",
                            password_confirmation: "password" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
