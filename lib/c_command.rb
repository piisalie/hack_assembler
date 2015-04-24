class CCommand
  attr_reader :command

  COMPUTATIONS = {
    '0'  => '101010',
    '1'  => '111111',
    '-1' => '111010',
    'D'  => '001100',
    'A'  => '110000',
    '!D' => '001101',
    '!A' => '110001',
    '-D' => '001111',
    '-A' => '110011',
    'D+1' => '011111',
    'A+1' => '110111',
    'D-1' => '001110',
    'A-1' => '110010',
    'D+A' => '000010',
    'D-A' => '010011',
    'A-D' => '000111',
    'D&A' => '000000',
    'D|A' => '010101',
    'M'  => '110000',
    '!M' => '110001',
    '-M' => '110011',
    'M+1' => '110111',
    'M-1' => '110010',
    'D+M' => '000010',
    'D-M' => '010011',
    'M-D' => '000111',
    'D&M' => '000000',
    'D|M' => '010101',
  }

  JUMPS = {
    nil   => '000',
    'JGT' => '001',
    'JEQ' => '010',
    'JGE' => '011',
    'JLT' => '100',
    'JNE' => '101',
    'JLE' => '110',
    'JMP' => '111',
  }

  def initialize(command)
    @command = command
    @dest = captures[:dest] || ''
    @comp = captures[:comp]
    @jump = captures[:jump]
  end

  def destination
    @dest.chars
  end

  def jump_condition
    @jump
  end

  def computation
    @comp
  end

  def pseudo?
    false
  end

  def to_string(symbol_table)
    '111' + a + COMPUTATIONS.fetch(computation) + destination_string + JUMPS.fetch(jump_condition)
  end

  def to_binary
    [to_string.to_i(2)].pack("n")
  end

  private

  def a
    return '0' unless computation.include?("M")
    '1'
  end

  def destination_string
    string = "000"
    string[0, 1] = "1" if destination.include?("A")
    string[1, 1] = "1" if destination.include?("D")
    string[2, 1] = "1" if destination.include?("M")
    string
  end

  def captures
    @captures ||= command.match(/\A(?:(?<dest>\w+)=)?(?<comp>[^;]+)(?:;(?<jump>\w+))?\z/)
  end

end
