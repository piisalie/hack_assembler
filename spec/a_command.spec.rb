require 'a_command'
require_relative 'spec_helper'

describe ACommand do

  def build_command(string)
    ACommand.new(string)
  end

  it 'knows when it is a label' do
    command = build_command('loop')
    command.label?.must_equal(true)
  end

  it 'knows when the command is an address' do
    command = build_command('0')
    command.label?.must_equal(false)
  end

  it 'can convert to actual binary' do
    command = build_command('32767')
    command.to_binary.must_equal("\x7f\xff".force_encoding('BINARY'))
  end

end
