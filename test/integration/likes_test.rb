require 'test_helper'

class LikesTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @micropost = microposts(:ants)
    @my_micropost = microposts(:orange)
    log_in_as(@user)
  end

  test "should like a micropost the standard way" do
    assert_difference "@micropost.likes.count",1 do
      post likes_path, params: {user_id: @user.id, micropost_id: @micropost.id}
    end
  end

  test "should like a micropost with Ajax" do
    assert_difference "@micropost.likes.count", 1 do
      post likes_path,xhr:true, params: {user_id: @user.id, micropost_id: @micropost.id}
    end
  end

  test "should unlike a micropost the standard way" do
    @micropost.like(@user)
    like = @micropost.likes.find_by(user_id: @user.id, micropost_id: @micropost.id)
    assert_difference '@micropost.likes.count', -1 do
      delete like_path(like), xhr: true
    end
  end

  test "should not like a my micropost with me" do
    assert_no_difference "@my_micropost.likes.count" do
      post likes_path, params: {user_id: @user.id, micropost_id: @my_micropost.id}
    end
  end
end
