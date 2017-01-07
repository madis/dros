# Transforms the source value into range of target values and picks element and
# returns element at index corresponding to the value from target_values
# collection
class NormalizedValue
  def self.pick(target_values, source_value, source_max)
    target_range = target_values.size.to_f
    index = source_value * (target_range / source_max)
    if index >= target_values.size
      target_values.last
    else
      target_values[index]
    end
  end
end
