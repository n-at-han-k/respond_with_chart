module RespondWithChart
  module ControllerHelper
    # Convenience method for use inside a respond_to block.
    #
    # Usage:
    #
    #   def show
    #     chart_json = {
    #       "red"  => [345345, 3245, 234, 23423, 234],
    #       "blue" => [3345, 33245, 34, 2323, 7734],
    #     }
    #
    #     respond_to do |format|
    #       json_or_png_chart(format, chart_json)
    #     end
    #   end
    #
    # GET /example.json  -> JSON body of chart_data
    # GET /example.png   -> rendered PNG (query params: w, h, type, title)
    #
    # @param format   [ActionController::MimeResponds::Collector]
    # @param chart_data [Hash{String,Symbol => Array<Numeric>}]
    # @param opts [Hash] extra options forwarded to ChartRenderer
    def json_or_png_chart(format, chart_data, opts = {})
      format.json do
        render json: chart_data
      end

      format.png do
        render_opts = opts.merge(
          w: params[:w],
          h: params[:h],
          type: params[:type],
          title: params[:title]
        ).compact

        png_blob = ChartRenderer.render_png(chart_data, render_opts)

        send_data png_blob,
                  type: 'image/png',
                  disposition: 'inline',
                  filename: 'chart.png'
      end
    end
  end
end
