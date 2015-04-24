require_relative 'parser'

class Assembler
  attr_reader :parser_class, :input_filename, :output_filename

  DEFAULT_SYMBOLS = {
    'SP'   => 0,
    'LCL'  => 1,
    'ARG'  => 2,
    'THIS' => 3,
    'THAT' => 4,
    'R0'   => 0,
    'SCREEN' => 16384,
    'KBD'    => 24576,
  }.tap { |h| 16.times { |n| h["R#{n}"] = n } }

  def initialize(output_filename: nil, input_filename:, parser_class: Parser)
    @input_filename  = input_filename
    @output_filename = output_filename || input_filename.gsub(/\.asm\z/, '.hack')
    @parser_class    = parser_class
    @symbol_table    = DEFAULT_SYMBOLS.dup
    @next_address    = 16
  end

  def autobots_assemble
    do_first_pass

    while command = parser.next_command
      if command.is_a?(ACommand) && command.label? && !@symbol_table.include?(command.command)
        @symbol_table[command.command] = @next_address
        @next_address += 1
      end

      output_file.puts(command.to_string(@symbol_table)) unless command.pseudo?
    end
  end

  def do_first_pass
    while command = parser.next_command
      @symbol_table[command.label] = command.line_number if command.pseudo?
    end
    @parser.file.rewind
  end

  def parser
    @parser ||= parser_class.new(file: input_file)
  end

  def input_file
    File.open(input_filename)
  end

  def output_file
    @output_file ||= File.open(output_filename, "w")
  end
end
