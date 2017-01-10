class BasicStats
  attr_reader :min, :max, :avg, :med

  def initialize(values = [])
    @values = values
    recalculate
  end

  def <<(value)
    @values << value
    recalculate
    self
  end

  private

  def recalculate
    calculate_min
    calculate_max
    calculate_avg
    calculate_med
  end

  def calculate_min
    @min = @values.min
  end

  def calculate_max
    @max = @values.max
  end

  def calculate_avg
    @avg = (@min + @max).to_f / 2
  end

  def calculate_med
    sorted = @values.sort
    len = sorted.length
    @med = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end
end
