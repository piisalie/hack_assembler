require_relative 'spec_helper'
require 'stringio'
require 'parser'

describe Parser do

  let(:klass) { Parser }

  class MockCommand
    attr_reader :line, :count

    def initialize(line:, count:, pseudo:)
      @line = line
      @count = count
      @pseudo = pseudo
    end

    def pseudo?
      !!@pseudo
    end

    def to_s
      @line
    end
  end

  let(:default_command_dictionary) do
    {
      /\A\w+:/ => ->(line, count) { MockCommand.new(line: line, count: count, pseudo: true) },
      /.*/     => ->(line, count) { MockCommand.new(line: line, count: count, pseudo: false) }
    }
  end

  def build_parser(contents:, command_dictionary: default_command_dictionary)
    file = StringIO.new(contents)
    klass.new(file: file, command_dictionary: command_dictionary)
  end

  describe "reads lines" do
    let(:parser) { build_parser(contents: "i=0\nsum=0\n") }

    it 'reads one line at a time' do
      parser.next_command.to_s.must_equal("i=0")
      parser.next_command.to_s.must_equal("sum=0")
    end

    it 'outputs nil if no more lines' do
      2.times do
        parser.next_command
      end

      parser.next_command.must_equal(nil)
    end
  end

  describe "command dictionary" do
    it 'matches the command class by regex' do
      some_command = Minitest::Mock.new
      command_dictionary = {
        /\A@/ => some_command
      }
      some_command.expect(:call, nil, [ "@something", 0 ])
      parser = build_parser(contents: "@something", command_dictionary: command_dictionary)
      parser.next_command
      some_command.verify
    end
  end

  describe "with comments" do
    it 'ignores them' do
      parser = build_parser(contents: "@loop    // this is a comment\ni=0\n // another one\nsum=2")
      parser.next_command.to_s.must_equal("@loop")
      parser.next_command.to_s.must_equal("i=0")
      parser.next_command.to_s.must_equal("sum=2")
    end
  end

  describe "blank lines" do
    it 'ignores them' do
      parser = build_parser(contents: "@loop\n \ni = 0")
      parser.next_command.to_s.must_equal("@loop")
      parser.next_command.to_s.must_equal("i=0")
    end
  end

  describe "line numbering" do
    it 'does not count l commands' do
      parser = build_parser(contents: "i=0\n\nloop:\n@something\n")
      parser.next_command.to_s.must_equal('i=0')
      pseudo_command = parser.next_command
      pseudo_command.to_s.must_equal('loop:')

      last_command = parser.next_command
      last_command.to_s.must_equal('@something')
      last_command.count.must_equal(pseudo_command.count)
    end
  end

end
