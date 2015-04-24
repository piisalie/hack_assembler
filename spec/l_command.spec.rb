require_relative 'spec_helper'
require 'l_command'

describe LCommand do

  it 'contains a label' do
    command = LCommand.new('loop')
    command.label.must_equal('loop')
  end

end
