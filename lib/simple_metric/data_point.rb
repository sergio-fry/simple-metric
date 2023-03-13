module SimpleMetric
  # Point Data type
  class DataPoint
    attr_reader :x, :y

    def initialize(abscissa, ordinate)
      @x = abscissa.to_f
      @y = ordinate.to_f
    end
  end
end
