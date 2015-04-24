class LCommand
  attr_reader :label, :line_number

  def initialize(label, line_number = nil)
    @label = label
    @line_number = line_number
  end

  def pseudo?
    true
  end

end
