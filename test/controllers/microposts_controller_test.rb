require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @micropost = microposts(:orange)
  end
  
  # 未ログイン時はcreateアクションは起こせずリダイレクトされる
  test "should redirect create when not loggeed in" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "ダミー" } }
    end
    assert_redirected_to login_url
  end
  
  # 未ログイン時はdestroyアクションは起こせずリダイレクトされる
  test "should redirect destroy when not logged in" do
    assert_no_difference "Micropost.count" do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
end
