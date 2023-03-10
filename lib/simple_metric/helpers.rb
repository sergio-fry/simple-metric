module SimpleMetric
  module Helpers
    extend self
    #   simple_metric_graph([[:metric_key, :title], [:metric_key_2, :title_2]])
    # OR
    #   simple_metric_graph([:metric_key, :metric_key_2])
    def simple_metric_graph(*metrics)
      return '' if metrics.blank?

      titles = {}
      metrics = find_metric(metrics, titles)
      dates = metrics.map(&:data_set_object).map(&:data_points).flatten.map(&:x).uniq.sort.map { |x| Time.at(x) }
      generate_html(metrics, titles, dates)
    end

    private

    def find_metric(metrics, titles)
      metrics.filter_map do |m|
        metric, title = m
        metric = metric.is_a?(Metric) ? metric : Metric.find_by(key: metric)
        next if metric.blank?

        titles[metric.id] = title || metric.key.mb_chars.titleize.to_s
        metric
      end
    end

    def generate_html(metrics, titles, dates)
      content_tag :div do
        concat content_tag(:div, nil, id: "metric_graph_#{metrics.map(&:id).join('_')}", style: 'width: 100%',
                                      class: 'dygraph_container')

        concat js_tag(metrics, titles, dates)
      end
    end

    def js_tag(metrics, titles, dates)
      javascript_tag <<-JS
        var container_id = "metric_graph_#{metrics.map(&:id).join('_')}";
        g = new Dygraph(

          // containing div
          document.getElementById(container_id),

          // CSV or path to a CSV file.
          "Date,#{metrics.map { |m| titles[m.id] }.join(',')}\\n" +
          "#{dates.map { |date| format_date(date, metrics) }.join }"
        );

        $("#" + container_id).data("dygraph", g);
      JS
    end

    def format_date(date, metrics)
      [date.strftime('%Y-%m-%d %H:%M'), metrics.map { |m| m.get_value(date) }].flatten.join(', ') + '\\n' # rubocop:disable Style/StringConcatenation
    end
  end
end

ActionView::Base.include(SimpleMetric::Helpers)
