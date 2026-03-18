require_relative 'test_helper'

class ChartsController < ActionController::Base
  include TestApp.routes.url_helpers

  def show
    chart_json = {
      'red' => [345_345, 3245, 234, 23_423, 234],
      'blue' => [3345, 33_245, 34, 2323, 7734]
    }

    respond_to do |format|
      json_or_png_chart(format, chart_json)
    end
  end
end

class ControllerHelperTest < ActionDispatch::IntegrationTest
  include TestApp.routes.url_helpers

  CHART_DATA = {
    'red' => [345_345, 3245, 234, 23_423, 234],
    'blue' => [3345, 33_245, 34, 2323, 7734]
  }.freeze

  def app
    TestApp
  end

  # -- JSON -----------------------------------------------------------------

  def test_json_returns_200
    get '/charts/show.json'
    assert_response :success
  end

  def test_json_content_type
    get '/charts/show.json'
    assert_equal 'application/json; charset=utf-8', response.content_type
  end

  def test_json_body_matches_chart_data
    get '/charts/show.json'
    parsed = JSON.parse(response.body)
    assert_equal CHART_DATA, parsed
  end

  # -- PNG ------------------------------------------------------------------

  def test_png_returns_200
    get '/charts/show.png'
    assert_response :success
  end

  def test_png_content_type
    get '/charts/show.png'
    assert_equal 'image/png', response.content_type
  end

  def test_png_body_is_valid_png
    get '/charts/show.png'
    assert response.body.b.start_with?("\x89PNG".b),
           'Expected response body to start with PNG signature'
  end

  def test_png_with_custom_dimensions
    get '/charts/show.png', params: { w: 600, h: 300 }
    assert_response :success
    assert response.body.b.start_with?("\x89PNG".b)
  end

  def test_png_with_type_param
    get '/charts/show.png', params: { type: 'bar' }
    assert_response :success
    assert response.body.b.start_with?("\x89PNG".b)
  end

  def test_png_with_title_param
    get '/charts/show.png', params: { title: 'Sales Report' }
    assert_response :success
    assert response.body.b.start_with?("\x89PNG".b)
  end

  def test_png_inline_disposition
    get '/charts/show.png'
    assert_match(/inline/, response.headers['Content-Disposition'])
  end
end
