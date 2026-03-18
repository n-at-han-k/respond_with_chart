require_relative 'test_helper'

class RailtieTest < Minitest::Test
  def test_png_mime_type_registered
    png_type = Mime::Type.lookup_by_extension(:png)
    refute_nil png_type, 'Expected Mime::Type for :png to be registered'
    assert_equal 'image/png', png_type.to_s
  end

  def test_controller_helper_included
    assert ActionController::Base.method_defined?(:json_or_png_chart),
           'Expected json_or_png_chart to be defined on ActionController::Base'
  end
end
