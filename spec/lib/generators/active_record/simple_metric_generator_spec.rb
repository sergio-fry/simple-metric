require 'generators/active_record/simple_metric_generator'
require 'fileutils'

RSpec.describe ActiveRecord::Generators::SimpleMetricGenerator do
  it 'migration must be created' do
    result = described_class.start ['Metric']
    expect(result.first).to be_truthy
  end
end
