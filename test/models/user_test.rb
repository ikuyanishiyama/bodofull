require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  # 有効なユーザーかどうかテストする
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid?" do
    assert @user.valid?
  end
  
  # nameは空欄は許されない
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  # emailは空欄は許されない
  test "email should be present" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  # nameは長すぎてはいけない
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  # emailは長すぎてはいけない
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  # 下記のメールアドレスは有効
  test "email validation should be accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  # 下記のメールアドレスは無効
  test "email validation should be reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be valid"
    end
  end
  
  # メールアドレスは唯一のものである
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  # パスワードは空欄ではいけない
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  # パスワードは6文字以上
  test "password should have a minimum length" do 
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end







