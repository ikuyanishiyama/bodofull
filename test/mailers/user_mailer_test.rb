require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  
  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "パスワード再設定", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@bodofull.com"], mail.from
    # assert_match user.reset_token, mail.body.encoded
  end

end
