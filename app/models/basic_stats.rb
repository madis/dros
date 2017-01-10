class BasicStats
  class NoValues < StandardError; end

  def initialize(values = [])
    @values = values
    @caluclated = false
  end

  def <<(value)
    @values << value
    @calculated = false
    self
  end

  def min
    calculate_if_needed
    @min
  end

  def max
    calculate_if_needed
    @max
  end

  def avg
    calculate_if_needed
    @avg
  end

  def med
    calculate_if_needed
    @med
  end

  private

  def calculate_if_needed
    recalculate unless @calculated
    @calculated = true
  end

  def recalculate
    raise NoValues, 'Can not calculate because no values' if @values.empty?
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
    @avg = @values.reduce(&:+).to_f / @values.count
  end

  def calculate_med
    sorted = @values.sort
    len = sorted.length
    @med = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end
end
