require File.dirname(__FILE__) + '/../spec_helper'

describe Help do
  before(:each) do
    @help = Help.new(:topic => 'BDD for you and me',:helpful_extension_id => '1')
  end

  it "belongs to a HelpfulExtension" do
    @help.helpful_extension_id = nil
    @help.should_not be_valid
  end

  it "requires a topic" do
    @help.topic = nil
    @help.should_not be_valid
  end
  
  it "should have a unique topic for the same HelpfulExtension" do
    @help.save
    @help2 = Help.new(:topic => 'BDD for you and me',:helpful_extension_id => '1')
    @help2.should_not be_valid
  end
  
  it "may have a non-unique topic with a different HelpfulExtension" do
    @help2 = Help.new(:topic => 'BDD for you and me',:helpful_extension_id => '2')
    @help2.should be_valid
  end
  
  it "has a description" do
    @help.description = "This is the description"
    @help.should be_valid
  end
end
