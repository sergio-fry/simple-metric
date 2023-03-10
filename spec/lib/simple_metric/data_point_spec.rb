RSpec.describe SimpleMetric::DataPoint do
  subject(:point) { described_class.new(x, y) }

  let(:x) { 10 }
  let(:y) { 20 }

  it { expect(point.x).to eq(x.to_f) }
  it { expect(point.y).to eq(y.to_f) }
end
