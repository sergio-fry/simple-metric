RSpec.describe SimpleMetric::DataSet do
  subject(:points_set) { described_class.new(data_points) }

  let(:data_points) do
    [[1, 2], [1, 3], [2, 4], [4, 5], [2, 6]].map { |point| SimpleMetric::DataPoint.new(*point) }
  end

  it 'data_points must be sorted by x' do
    points = points_set.data_points.map { |obj| [obj.x, obj.y] }
    expect(points).to eq(
      [[1.0, 2.0], [1.0, 3.0], [2.0, 4.0], [2.0, 6.0], [4.0, 5.0]]
    )
  end

  describe '#get_value' do
    it 'retun y if x presence' do
      expect(points_set.get_value(1)).to eq(2.0)
    end

    context 'when value absent in set' do
      it 'retun avg if x in range' do
        expect(points_set.get_value(3)).to eq(4.5)
      end

      it 'retun nil if x before range' do
        expect(points_set.get_value(0)).to be_nil
      end

      it 'retun nil if x after range' do
        expect(points_set.get_value(5)).to be_nil
      end
    end
  end
end
