require 'gruff'

module RespondWithChart
  class ChartRenderer
    DEFAULT_WIDTH  = 800
    DEFAULT_HEIGHT = 600
    DEFAULT_CHART_TYPE = :line

    # Renders chart_data to a PNG blob.
    #
    # @param chart_data [Hash{String,Symbol => Array<Numeric>}]
    #   Each key is a series name (used in the legend), each value is an array
    #   of data points.  Example:
    #     { "red" => [10, 20, 30], "blue" => [5, 15, 25] }
    #
    # @param opts [Hash] optional rendering overrides
    # @option opts [Integer] :w       width in pixels  (default 800)
    # @option opts [Integer] :h       height in pixels (default 600)
    # @option opts [Symbol]  :type    Gruff chart class name downcased
    #                                 (:line, :bar, :area, etc.)
    # @option opts [String]  :title   chart title
    # @option opts [Hash,Array] :labels  x-axis labels forwarded to Gruff
    #
    # @return [String] binary PNG data
    def self.render_png(chart_data, opts = {})
      width  = (opts[:w] || DEFAULT_WIDTH).to_i
      height = (opts[:h] || DEFAULT_HEIGHT).to_i
      type   = (opts[:type] || DEFAULT_CHART_TYPE).to_s.capitalize.to_sym

      klass = begin
        Gruff.const_get(type)
      rescue NameError
        Gruff::Line
      end

      chart = klass.new("#{width}x#{height}")
      chart.title  = opts[:title] if opts[:title]
      chart.labels = opts[:labels] if opts[:labels]

      chart_data.each do |series_name, points|
        chart.data(series_name.to_s, Array(points))
      end

      chart.to_image.to_blob
    end
  end
end
