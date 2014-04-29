# SimpleMetric

Rails metric solution. Store data-points, display graphs. Based on dygraphs js lib.

## Installation

Add this line to your application's Gemfile:

    gem 'simple-metric'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple-metric

Add migration:

    $ rails g migration create_metrics

Insert that:
    
    ...

    def change
      create_table :metrics do |t|
        t.string :key
        t.text :data_set

        t.timestamps
      end

      add_index :metrics, :key, :unique => true
    end

    ...

Run migration:

    $ rake db:migrate


Include dygraph js lib into your application.js:

    //= require dygraph-combined

## Usage

Add some data points:

    SimpleMetric::Metric.add_data_point "Users count", 30.days.ago, 10
    SimpleMetric::Metric.add_data_point "Users count", 20.days.ago, 15
    SimpleMetric::Metric.add_data_point "Users count", 10.days.ago, 25

Display graph into your erb template:

    <%= simple_metric_graph "Users count" %>

Plot multiple metrics:

    <%= simple_metric_graph "metric_1", "metric_2" %>

Add custom titles:

    <%= simple_metric_graph ["metric_1", "Title for metric 1"], ["metric_2", "Title 2"] %>


## Contributing

1. Fork it ( https://github.com/sergio-fry/simple-metric/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
