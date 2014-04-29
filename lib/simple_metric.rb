require "simple_metric/version"
require "ostruct"

module SimpleMetric
  module Helpers
    module Rails
      class Engine < ::Rails::Engine
      end
    end


    #   simple_metric_graph([[:metric_key, :title], [:metric_key_2, :title_2]])
    # OR
    #   simple_metric_graph([:metric_key, :metric_key_2])
    def simple_metric_graph(*metrics)
      if metrics.blank?
        ""
      else
        titles = {}

        metrics = metrics.map do |m|
          metric, title = m

          metric = metric.is_a?(Metric) ? metric : Metric.find_by(key: metric)

          next if metric.blank?

          titles[metric.id] = title || metric.key.mb_chars.titleize.to_s

          metric
        end.compact

        # values[date][metric_id]
        values = {}

        metrics.each do |metric|
          metric.data_points.each do |point|
            values[point.date.strftime("%Y-%m-%d %H:%M")] ||= {}
            values[point.date.strftime("%Y-%m-%d %H:%M")][metric.id] = point.value
          end
        end

        dates = values.keys.sort

        get_value = lambda do  |date, metric_id|
          value = values[date][metric_id]

          if value.blank?
            if dates.first == date
              value = nil
            else
              value = get_value.call(dates[dates.index(date) - 1], metric_id)
            end
          end

          value
        end

        content_tag :div do
          concat content_tag(:div, nil, :id => "metric_graph_#{metrics.map(&:id).join("_")}", :style => "width: 100%", :class => "dygraph_container")

          concat javascript_tag <<-JS
          var container_id = "metric_graph_#{metrics.map(&:id).join("_")}";
          g = new Dygraph(

            // containing div
            document.getElementById(container_id),

            // CSV or path to a CSV file.
            "Date,#{metrics.map{ |m| titles[m.id] }.join(',')}\\n" +
            "#{dates.map { |date| [date, metrics.map { |m| get_value.call(date, m.id) }].flatten.join(", ") + "\\n" }.join("")}"

          );

          $("#" + container_id).data("dygraph", g);
          JS
        end
      end
    end
  end

  class Metric < ActiveRecord::Base
    serialize :data_set
    validates :key, :presence => true, :uniqueness => true

    def self.add_data_point(key, date, value)
      find_or_create_by(:key => key).add_data_point(date, value)
    end

    def add_data_point(date, value)
      self.data_set ||= []

      raise "value '#{value}' is not a number" unless value.is_a? Numeric

      data_set << [date.to_time, value]

      save!
    end

    class DataPoint < OpenStruct
    end

    def data_points
      if data_set.present?
        data_set.map { |row| DataPoint.new({ :date => row[0], :value => row[1] }) }
      end
    end

    def title
      self[:title] || "Metric ##{id}"
    end
  end
end

ActionView::Base.send :include, SimpleMetric::Helpers