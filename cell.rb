class Cell
  attr_accessor :row, :column, :block
  attr_reader :value, :candidates

  def initialize(params = {})
    @candidates = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  def set_value(v)
    return false unless @value.nil?
    @value = v
    @candidates = []
    true
  end

  def <=>(other)
    return @column <=> other.column if @row == other.row
    @row <=> other.row
  end

  def remove_candidate(candidate)
    @candidates.reject! { |c| c == candidate}
  end

  def solved?
    @value != nil
  end

  def to_s
    return ' ' if @value == nil
    return @value.to_s
  end
end
