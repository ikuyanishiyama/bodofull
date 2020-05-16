require 'test_helper'

class SiteLayoutsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  # Homeページにアクセスできるか
  # Home、Aboutの各ページへのリンクが正しく動くか
  test "layout links" do
    get root_path
    assert_template "static_pages/home"
    assert_select "a[href=?]", root_path, coutn: 2
    assert_select "a[href=?]", about_path
    get about_path
    assert_select "title", full_title("ボドフルとは")
  end
end
