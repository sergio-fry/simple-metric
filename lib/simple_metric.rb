require "simple_metric/version"
require "ostruct"
require 'spliner'

module SimpleMetric
  module Rails
    class Engine < ::Rails::Engine
    end
  end

  module Helpers

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

        dates = metrics.map(&:data_set_object).map(&:data_points).flatten.map(&:x).uniq.sort.map { |x| Time.at(x) }


        content_tag :div do
          concat content_tag(:div, nil, :id => "metric_graph_#{metrics.map(&:id).join("_")}", :style => "width: 100%", :class => "dygraph_container")

          concat javascript_tag <<-JS
          var container_id = "metric_graph_#{metrics.map(&:id).join("_")}";
          g = new Dygraph(

            // containing div
            document.getElementById(container_id),

            // CSV or path to a CSV file.
            "Date,#{metrics.map{ |m| titles[m.id] }.join(',')}\\n" +
            "#{dates.map { |date| [date.strftime("%Y-%m-%d %H:%M"), metrics.map { |m| m.get_value(date) }].flatten.join(", ") + "\\n" }.join("")}"

          );

          $("#" + container_id).data("dygraph", g);
          JS
        end
      end
    end
  end

  class DataSet
    attr_reader :data_points

    def initialize(data_points)
      @data_points = data_points.sort_by { |point| point.x }
      @spliner = Spliner::Spliner.new(@data_points.map(&:x), @data_points.map(&:y))
    end

    def get_value(x)
      @spliner[x.to_f]
    end
  end

  class DataPoint
    attr_reader :x, :y

    def initialize(x, y)
      @x, @y = x.to_f, y.to_f
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

    def get_value(date)
      @data_set_object ||= data_set_object

      @data_set_object.get_value(date.to_f)
    end

    def data_set_object
      if data_set.present?
        DataSet.new(data_points)
      end
    end

    def data_points
      if data_set.present?
        data_set.map { |row| DataPoint.new(row[0], row[1]) }
      end
    end
  end
end

ActionView::Base.send :include, SimpleMetric::Helpers
