require_relative 'test_helper'

class ChartRendererTest < Minitest::Test
  CHART_DATA = {
    'red' => [10, 20, 30, 40, 50],
    'blue' => [50, 40, 30, 20, 10]
  }.freeze

  def test_render_png_returns_binary_string
    blob = RespondWithChart::ChartRenderer.render_png(CHART_DATA)
    assert_kind_of String, blob
    refute blob.empty?
  end

  def test_render_png_starts_with_png_signature
    blob = RespondWithChart::ChartRenderer.render_png(CHART_DATA)
    # PNG files always start with these 8 bytes
    assert_equal "\x89PNG\r\n\x1A\n".b, blob[0, 8]
  end

  def test_custom_dimensions
    blob_small = RespondWithChart::ChartRenderer.render_png(CHART_DATA, w: 200, h: 100)
    blob_large = RespondWithChart::ChartRenderer.render_png(CHART_DATA, w: 1200, h: 800)

    # Both should be valid PNGs
    assert blob_small.start_with?("\x89PNG".b)
    assert blob_large.start_with?("\x89PNG".b)

    # Larger chart should produce a larger blob (not guaranteed but very likely)
    assert blob_large.bytesize > blob_small.bytesize,
           "Expected large chart (#{blob_large.bytesize}B) to be bigger than small (#{blob_small.bytesize}B)"
  end

  def test_bar_chart_type
    blob = RespondWithChart::ChartRenderer.render_png(CHART_DATA, type: :bar)
    assert blob.start_with?("\x89PNG".b)
  end

  def test_area_chart_type
    blob = RespondWithChart::ChartRenderer.render_png(CHART_DATA, type: :area)
    assert blob.start_with?("\x89PNG".b)
  end

  def test_unknown_type_falls_back_to_line
    blob = RespondWithChart::ChartRenderer.render_png(CHART_DATA, type: :nonexistent)
    assert blob.start_with?("\x89PNG".b)
  end

  def test_with_title
    blob = RespondWithChart::ChartRenderer.render_png(CHART_DATA, title: 'Test Chart')
    assert blob.start_with?("\x89PNG".b)
  end

  def test_with_labels
    labels = { 0 => 'Mon', 1 => 'Tue', 2 => 'Wed', 3 => 'Thu', 4 => 'Fri' }
    blob = RespondWithChart::ChartRenderer.render_png(CHART_DATA, labels: labels)
    assert blob.start_with?("\x89PNG".b)
  end

  def test_single_series
    blob = RespondWithChart::ChartRenderer.render_png({ 'only' => [1, 2, 3] })
    assert blob.start_with?("\x89PNG".b)
  end

  def test_symbol_keys
    data = { red: [10, 20], blue: [30, 40] }
    blob = RespondWithChart::ChartRenderer.render_png(data)
    assert blob.start_with?("\x89PNG".b)
  end
end
