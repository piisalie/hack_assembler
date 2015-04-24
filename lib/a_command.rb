class ACommand

  attr_reader :command

  def initialize(command)
    @command = command
  end

  def label?
    !command.match(/\A\d+\z/)
  end

  def pseudo?
    false
  end

  def to_binary
    [command.to_i].pack('n')
  end

  def to_string(symbol_table)
    if label?
      sprintf('%016b', symbol_table.fetch(command))
    else
      sprintf('%016b', command.to_i)
    end
  end

end
