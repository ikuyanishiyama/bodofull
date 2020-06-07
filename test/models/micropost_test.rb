require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "コードネーム")
  end
  
  # バリデーションのテスト
  test "should be valid" do
    assert @micropost.valid?
  end
  
  # user_idが紐付けされている
  test "user should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  # contentが入力されている
  test "content should be present" do
    @micropost.content = ""
    assert_not @micropost.valid?
  end
  
  # contentは140字以内
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  # 最新の投稿が先頭に表示される
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
  
  
end
