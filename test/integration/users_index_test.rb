require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: '削除'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: '削除', count: 0
  end

  test "search user" do
    log_in_as(@admin)
    get users_path
    get users_path, params: {search: "archer"}
    first_page_of_users = User.paginate(page: 1).search_user("archer")
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), count: 2
    end

    #検索ヒットが0件の時
    get users_path
    first_page_of_users = User.paginate(page: 1).search_user("aaaarewweraaaa")
    assert first_page_of_users.count == 0
  end

  test "search user empty word" do
    log_in_as(@admin)
    get users_path
    get users_path, params: {search: ""}
    first_page_of_users = User.paginate(page: 1).search_user("")
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

end
