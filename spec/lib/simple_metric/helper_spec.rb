require 'spec_helper'

RSpec.describe SimpleMetric::Helpers do
  let(:dummy_class) do
    Class.new do
      extend SimpleMetric::Helpers
      extend ActionView::Helpers
      extend ActionView::Context
    end
  end

  describe '.simple_metric_graph' do
    let(:html_file) { File.read(Rails.root.join('../fixtures/tags.html')) }

    before do
      Timecop.freeze(Time.local(2023, 2, 8, 0, 0, 0)) do
        SimpleMetric::Metric.add_data_point('Test Key', Time.now, 10)
      end
    end

    it 'return blank if no metrics' do
      expect(dummy_class.simple_metric_graph).to eq('')
    end

    it 'return blank if empty array' do
      out_html = dummy_class.simple_metric_graph('Test Key')

      expect(HtmlCompressor::Compressor.new.compress(out_html))
        .to eq(HtmlCompressor::Compressor.new.compress(html_file))
    end
  end
end
