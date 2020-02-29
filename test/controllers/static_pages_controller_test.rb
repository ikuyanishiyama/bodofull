require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "ボドフル＊ボードゲーム口コミサイト"
  end
  
  test "rootにアクセス" do
    get root_url
    assert_response :success
    assert_select "title", "みんなのオススメ | #{@base_title}"
  end
  
  test "homeにアクセス" do
    get home_path
    assert_response :success
    assert_select "title", "みんなのオススメ | #{@base_title}"
  end

  test "aboutページにアクセス" do
    get about_path
    assert_response :success
    assert_select "title", "ボドフルとは | #{@base_title}"
  end

end
