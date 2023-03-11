require 'spec_helper'

RSpec.describe SimpleMetric::Helpers do
  let(:dummy_class) do
    Class.new do
      extend SimpleMetric::Helpers
    end
  end

  describe '.simple_metric_graph' do
    before do
      Timecop.freeze(Time.local(2023, 2, 8, 0, 0, 0)) do
        SimpleMetric::Metric.add_data_point('Test Key', Time.now, 10)
      end
    end

    it 'return blank if no metrics' do
      expect(dummy_class.simple_metric_graph).to eq('')
    end
  end
end
