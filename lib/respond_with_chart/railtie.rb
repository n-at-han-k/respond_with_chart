require 'rails/railtie'

module RespondWithChart
  class Railtie < Rails::Railtie
    initializer 'respond_with_chart.register_mime_type' do
      # Register .png as a MIME type so respond_to { |f| f.png } works.
      # Skip if already registered (e.g. by another gem).
      Mime::Type.register 'image/png', :png unless Mime::Type.lookup_by_extension(:png)
    end

    initializer 'respond_with_chart.include_helper' do
      ActiveSupport.on_load(:action_controller) do
        include RespondWithChart::ControllerHelper
      end
    end
  end
end
