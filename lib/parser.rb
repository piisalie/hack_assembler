require_relative 'l_command'
require_relative 'c_command'
require_relative 'a_command'

class Parser

  attr_reader :command_dictionary, :file

  DEFAULT_DICTIONARY = {
    /\A@/  => ->(line, count) { ACommand.new(line[1..-1]) },
    /\A\(/ => ->(line, count) { LCommand.new(line[1..-2], count) },
    /\A/   => ->(line, count) { CCommand.new(line) },
  }

  def initialize(file:, command_dictionary: DEFAULT_DICTIONARY)
    @file = file.to_enum
    @command_dictionary = command_dictionary
    @count = 0
  end

  def next_command
    line = remove_whitespace(remove_comments(next_file_line))
    return next_command if line.empty?

    command = command_dictionary.find { |k,v|
      line =~ k
    }.last.call(line, @count)

    @count += 1 unless pseudo?(command)
    command

    rescue StopIteration
      return nil
  end

  private

  def pseudo?(command)
    command.respond_to?(:pseudo?) && command.pseudo?
  end

  def next_file_line
    file.next.chomp
  end

  def remove_comments(line)
    line.sub(/\s*\/\/.*/, '')
  end

  def remove_whitespace(line)
    line.gsub(/\s+/, '')
  end

end
