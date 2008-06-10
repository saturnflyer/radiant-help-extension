require File.dirname(__FILE__) + '/../spec_helper'

describe Help do
  before(:each) do
    @help = Help.new(:name => 'TestExtension')
  end

  it "requires a name" do
    @help.name = nil
    @help.should_not be_valid
  end
end
