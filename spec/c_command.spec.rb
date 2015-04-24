require_relative 'spec_helper'
require 'c_command'

describe CCommand do

  def build_command(string)
    CCommand.new(string)
  end

  it 'has an optional destination' do
    command = build_command('AD=1')
    command.destination.must_equal(['A', 'D'])
  end

  it 'has a computation' do
    command = build_command('D=D+1')
    command.computation.must_equal('D+1')
  end

  it 'has an optional jump' do
    command = build_command('0;JEQ')
    command.jump_condition.must_equal('JEQ')
  end

  it 'can convert 0;JEQ to a stringy binary thingy' do
    command = build_command('0;JEQ')
    command.to_string.must_equal('1110101010000010')
  end

  it 'can convert AD=-1 to actual binary' do
    binary = ['1110111010110000'.to_i(2)].pack("n")
    command = build_command('AD=-1')
    command.to_binary.must_equal(binary)
  end

end
