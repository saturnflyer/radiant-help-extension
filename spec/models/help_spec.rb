require File.dirname(__FILE__) + '/../spec_helper'

describe Help do
  before(:each) do
    @help = Help.new
  end

  it "should be valid" do
    @help.should be_valid
  end
end
