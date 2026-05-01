# respond_with_chart

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/n-at-han-k/respond_with_chart)

A Rails Railtie that lets you serve JSON **and** PNG charts from the same
controller action. Request `.json` and you get raw data. Request `.png` and
you get a [Gruff](https://github.com/topfunky/gruff)-rendered chart image.

## Install

```ruby
# Gemfile
gem "respond_with_chart"
```

Requires ImageMagick on the host (Gruff depends on RMagick).

## Basic usage

```ruby
class ReportsController < ApplicationController
  def show
    chart_data = {
      "revenue"  => [12_000, 18_000, 22_000, 30_000],
      "expenses" => [10_000, 14_000, 19_000, 24_000],
    }

    respond_to do |format|
      json_or_png_chart(format, chart_data)
    end
  end
end
```

That single action now responds to two formats:

```
GET /reports/1.json
# => {"revenue":[12000,18000,22000,30000],"expenses":[10000,14000,19000,24000]}

GET /reports/1.png
# => 800x600 PNG line chart (inline)
```

## Controlling size via query params

Width and height are set with `w` and `h`:

```
GET /reports/1.png?w=1200&h=400
```

Defaults to 800x600 when omitted.

## Choosing a chart type

Pass `type` as a query param. Any Gruff chart class name works (lowercased):

```
GET /reports/1.png?type=bar
GET /reports/1.png?type=area
GET /reports/1.png?type=pie
GET /reports/1.png?type=stacked_bar
```

Defaults to `line`. Unknown types fall back to `line`.

## Adding a title

```
GET /reports/1.png?title=Q4+Revenue
```

## Combining params

```
GET /reports/1.png?w=1024&h=512&type=bar&title=Quarterly+Report
```

## Passing options from the controller

The third argument to `json_or_png_chart` lets you set defaults that query
params can still override:

```ruby
def show
  data = { "sales" => [100, 200, 300] }

  respond_to do |format|
    json_or_png_chart(format, data, {
      w: 1024,
      h: 400,
      type: :bar,
      title: "Monthly Sales",
      labels: { 0 => "Jan", 1 => "Feb", 2 => "Mar" },
    })
  end
end
```

## Using it with real data

```ruby
class DashboardController < ApplicationController
  def traffic
    stats = Ahoy::Visit.group_by_day(:started_at, last: 30).count

    chart_data = {
      "visits" => stats.values,
    }

    respond_to do |format|
      json_or_png_chart(format, chart_data, {
        labels: stats.keys.each_with_index.to_h { |date, i| [i, date.strftime("%b %d")] },
        title: "Last 30 days",
      })
    end
  end
end
```

## Embedding charts in HTML

Because the PNG endpoint is a plain URL, you can use it directly in `<img>`
tags or link to the JSON for JavaScript charting libraries:

```erb
<img src="<%= dashboard_traffic_path(format: :png, w: 700, h: 350) %>" />
```

## Using ChartRenderer directly

You don't have to go through a controller. `ChartRenderer.render_png` returns
a binary PNG string:

```ruby
blob = RespondWithChart::ChartRenderer.render_png(
  { "a" => [1, 2, 3], "b" => [3, 2, 1] },
  w: 600, h: 300, type: :bar, title: "Comparison"
)

File.binwrite("chart.png", blob)
```

## What the gem does at boot

The Railtie runs two initializers:

1. Registers `image/png` as a MIME type for the `:png` format (so
   `respond_to { |f| f.png }` works).
2. Includes the `json_or_png_chart` helper into all controllers.

No configuration needed.

## Running the example app

```
cd example
bundle install
bin/rails server
```

Visit `http://localhost:3000` to see charts rendered inline, with links to
both the `.json` and `.png` endpoints for each dataset.

## Running tests

```
bundle install
bundle exec rake test
```
