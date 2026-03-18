class ChartsController < ApplicationController
  DATASETS = {
    'sales' => {
      'Q1' => [12_000, 15_000, 13_000],
      'Q2' => [18_000, 21_000, 17_000],
      'Q3' => [22_000, 19_000, 24_000],
      'Q4' => [30_000, 28_000, 32_000]
    },
    'traffic' => {
      'organic' => [4000, 4500, 5200, 6100, 7300],
      'referral' => [1200, 1400, 1100, 1800, 2100],
      'direct' => [800, 900, 950, 1000, 1100]
    },
    'colors' => {
      'red' => [345_345, 3245, 234, 23_423, 234],
      'blue' => [3345, 33_245, 34, 2323, 7734]
    }
  }.freeze

  def index
    render inline: <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>respond_with_chart example</title>
        <style>
          body { font-family: system-ui, sans-serif; max-width: 900px; margin: 2rem auto; padding: 0 1rem; }
          h1 { border-bottom: 2px solid #333; padding-bottom: .5rem; }
          .chart-card { margin: 1.5rem 0; padding: 1rem; border: 1px solid #ddd; border-radius: 8px; }
          .chart-card h2 { margin-top: 0; }
          a { color: #0366d6; }
          img { max-width: 100%; height: auto; border: 1px solid #eee; border-radius: 4px; }
          code { background: #f0f0f0; padding: 2px 6px; border-radius: 3px; }
        </style>
      </head>
      <body>
        <h1>respond_with_chart examples</h1>
        <p>Each chart is available as <code>.json</code> or <code>.png</code> from the same URL.</p>

        #{DATASETS.keys.map.with_index(1) { |name, id| chart_card(name, id) }.join}
      </body>
      </html>
    HTML
  end

  def show
    dataset_name = DATASETS.keys[params[:id].to_i - 1] || 'colors'
    chart_data = DATASETS[dataset_name]

    respond_to do |format|
      json_or_png_chart(format, chart_data)
    end
  end

  private

  def chart_card(name, id)
    <<~HTML
      <div class="chart-card">
        <h2>#{name}</h2>
        <p>
          <a href="/charts/#{id}.json">JSON</a> |
          <a href="/charts/#{id}.png?w=700&h=350">PNG (700x350)</a> |
          <a href="/charts/#{id}.png?w=700&h=350&type=bar">PNG bar chart</a>
        </p>
        <img src="/charts/#{id}.png?w=700&h=350" alt="#{name} chart" />
      </div>
    HTML
  end
end
