require 'spliner'
require_relative 'data_point'

module SimpleMetric
  # Set of points
  class DataSet
    TAKE_POINTS = 2

    attr_reader :data_points

    def initialize(data_points)
      @data_points = data_points.sort_by(&:x)
    end

    def get_value(x_num)
      x = x_num.to_f
      value = @data_points.find { |point| point.x == x }.try(:y)

      if value.blank?
        points = [points_before(x, TAKE_POINTS), points_after(x, TAKE_POINTS)].flatten

        spliner = Spliner::Spliner.new(points.map(&:x), points.map(&:y))
        return spliner[x]
      end

      value
    end

    private

    def points_before(x_num, count)
      @data_points.reverse.each_with_object([]) do |point, acc|
        return acc.sort_by(&:x) if acc.size >= count

        acc << point if point.x <= x_num
      end
    end

    def points_after(x_num, count)
      @data_points.each_with_object([]) do |point, acc|
        return acc if acc.size >= count

        acc << point if point.x >= x_num
      end
    end
  end
end
