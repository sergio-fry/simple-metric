module SimpleMetric
  class Metric < ActiveRecord::Base
    MAX_SIZE = 1000

    serialize :data_set
    validates :key, presence: true, uniqueness: true

    # @param [String] key.
    # @param [Time] date.
    # @param [Numeric] value.
    #
    # @return [true]
    def self.add_data_point(key, date, value)
      find_or_create_by(key: key).add_data_point(date, value)
    end

    # @example ['String', 'Time', 'Numeric']
    # @param [String] key.
    # @param [Time] date.
    # @param [Numeric] value.
    def self.add_data_points(*points)
      points.each do |point|
        find_or_create_by(key: point[0]).add_data_point(point[1], point[2])
      end
    end

    # @param [Time] date.
    # @param [Numeric] value.
    #
    # @return [true]
    def add_data_point(date, value)
      raise "value '#{value}' is not a number" unless value.is_a? Numeric

      self.data_set ||= []
      data_set << [date.to_time, value]
      data_set.shift(data_set.size - MAX_SIZE) if data_set.size > MAX_SIZE
      save!
    end

    def get_value(date)
      @data_set_object ||= data_set_object
      @data_set_object.get_value(date.to_f)
    end

    def data_set_object
      return unless data_set.present?

      DataSet.new(data_points)
    end

    def data_points
      return unless data_set.present?

      data_set.map { |row| DataPoint.new(row[0], row[1]) }
    end
  end
end
