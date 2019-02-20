require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "Twwwitter"
    assert_equal full_title("Contact"), "Contact | Twwwitter"
  end
end
