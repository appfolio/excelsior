require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def test_anonymous_name__anonymous
    assert_equal "Someone anonymous", view.anonymous_name(true, "name")
  end

  def test_anonymous_name__not_anonymous
    assert_equal "name", view.anonymous_name(false, "name")
  end

  def test_anonymous_name__overwrite_name
    assert_equal "Anonymouse", view.anonymous_name(true, "name", "Anonymouse")
  end

  def test_anonymous_name__overwrite_name__not_anonymous
    assert_equal "name", view.anonymous_name(false, "name", "Anonymouse")
  end
end
