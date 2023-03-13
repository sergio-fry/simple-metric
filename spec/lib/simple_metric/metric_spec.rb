require 'spec_helper'

RSpec.describe SimpleMetric::Metric do
  describe '.add_data_point' do
    let(:metric) { described_class.add_data_point('Test Key', Time.now, 10) }

    it 'MAX_SIZE data_set' do
      stub_const('SimpleMetric::Metric::MAX_SIZE', 2)
      (described_class::MAX_SIZE + 2).times do |i|
        described_class.add_data_point('Test Key', (10 + 1).minutes.ago, (5 + i))
      end
      expect(described_class.find_by(key: 'Test Key').data_set.count).to eq(2)
    end

    it 'only one metric create' do
      2.times { metric }
      expect(described_class.count).to eq(1)
    end
  end

  describe '.add_data_points' do
    let(:metrics_data) { [['test1', Time.now, 10], ['test2', Time.now, 20]] }
    let(:metrics) { described_class.add_data_points(*metrics_data) }

    it 'all metrics was created' do
      expect { metrics }.to change(described_class, :count).from(0).to(2)
    end

    it 'data_set content correct value' do
      metrics
      metrics_data.each do |metric|
        expect(described_class.find_by(key: metric[0]).data_set.dig(0, 1)).to eq(metric[2])
      end
    end
  end

  describe '#add_data_point' do
    let(:metric) { described_class.new(key: 'Test Key').add_data_point(Time.now, 10) }

    it 'return true' do
      expect(metric).to be_truthy
    end

    it 'metric was created' do
      expect { metric }.to change(described_class, :count).from(0).to(1)
    end

    it 'data_set was created' do
      Timecop.freeze do
        metric
        expect(described_class.last.data_set).to eq([[Time.now, 10]])
      end
    end

    context 'when wrong params' do
      it 'raise error if value not a Number' do
        expect { described_class.new(key: 'Wrong Test Key').add_data_point(Time.now, '10') }
          .to raise_error(RuntimeError, "value '10' is not a number")
      end
    end
  end

  describe '#data_set_object' do
    let(:data_set) { described_class.find_by(key: 'Test Key').data_set_object }

    before { described_class.add_data_point('Test Key', Time.now, 10) }

    it 'contains data_set object' do
      expect(data_set).to be_instance_of(SimpleMetric::DataSet)
    end
  end

  describe '#data_points' do
    let(:data_points) { described_class.find_by(key: 'Test Key').data_points }

    before { described_class.add_data_point('Test Key', Time.now, 10) }

    it 'must be array' do
      expect(data_points).to be_a(Array)
    end

    it 'containts DataPoints' do
      expect(data_points).to be_all(SimpleMetric::DataPoint)
    end
  end

  describe '#get_value' do
    let(:value) { described_class.find_by(key: 'Test Key').get_value(Time.now) }

    it do
      Timecop.freeze do
        described_class.add_data_point('Test Key', Time.now, 10)
        expect(value).to eq(10)
      end
    end
  end
end
