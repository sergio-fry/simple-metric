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
        t.string :title
        t.string :key
        t.text :data_set

        t.timestamps
      end

      add_index :metrics, :key, :unique => true
    end

    ...

Run migration:

    $ rake db:migrate

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/simple-metric/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
