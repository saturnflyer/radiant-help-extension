require File.dirname(__FILE__) + '/../spec_helper'

describe HelpfulExtension do
  before(:each) do
    @helpful_extension = HelpfulExtension.new(:name => 'TestExtension')
  end

  it "requires a name" do
    @helpful_extension.name = nil
    @helpful_extension.should_not be_valid
  end
    
  it "has an author name" do
    @helpful_extension.author_name = "Jim Gay"
    @helpful_extension.should be_valid
  end
  
  it "has an author contact" do
    @helpful_extension.author_contact = "email@nospam.com"
    @helpful_extension.should be_valid
  end
  
  describe "when registering in the database with HelpfulExtension.register" do
    it "should raise a HelpfulExtension::DetailsError without a name" do
      lambda {
        @ext = HelpfulExtension.register()
      }.should raise_error(HelpfulExtension::DetailsError)
    end
    
    it "should reject unknown attributes with a HelpfulExtension::DetailsError" do
      lambda {
        @ext = HelpfulExtension.register(:name => 'Other Test', :other => 'Whoops!')
      }.should raise_error(HelpfulExtension::DetailsError)
    end
  end
  
  describe "registered in the database" do
    before(:each) do
      @helpful_extension.save!
    end
  
    it "should unregister an extension by name with HelpfulExtension.unregister" do 
      HelpfulExtension.unregister('TestExtension').should be_true
    end
    
    it "should not unregister an extension that does not exist" do
      HelpfulExtension.unregister('WhatThe?').should_not be_true
    end
  end
end
