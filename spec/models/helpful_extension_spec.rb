require File.dirname(__FILE__) + '/../spec_helper'

describe HelpfulExtension do
  before(:each) do
    @helpful_extension = HelpfulExtension.new(:name => 'TestExtension')
  end

  it "requires a name" do
    @helpful_extension.name = nil
    @helpful_extension.should_not be_valid
  end
  
  describe "when registering in the database with HelpfulExtension.register"
    it "should raise a HelpfulExtension::DetailsError without a name"
    
    it "should accept author name"
    
    it "should accept author contact"
    
    it "should reject other attributes with a HelpfulExtension::DetailsError"
  end
  
  describe "registered in the database"
    before(:each) do
      @helpful_extension.save!
    end
  
    it "should unregister an extension by name with HelpfulExtension.unregister" do
    
    end
  end
end
