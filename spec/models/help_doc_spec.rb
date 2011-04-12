require File.dirname(__FILE__) + '/../spec_helper'

describe HelpDoc, "given existing extension docs" do
    
  before(:all) do
    @test_ext_name = "help_rspec_test#{rand(1000)}"
    @test_dir = "#{RAILS_ROOT}/vendor/extensions/#{@test_ext_name}"
    FileUtils.mkdir(@test_dir)
    File.open("#{@test_dir}/HELP", 'wb') {|f| f.write('help for all') }
    File.open("#{@test_dir}/HELP_developer.rdoc", 'wb') {|f| f.write('== Testing
help for developers in rdoc
') }
    File.open("#{@test_dir}/HELP_admin.markdown", 'wb') {|f| f.write('Test
----
help for admins in **markdown**
') }
    File.open("#{@test_dir}/HELP_imaginary.md", 'wb') {|f| f.write('## Test
help for non-existent role in **markdown**
') }
    File.open("#{@test_dir}/HELP_other.textile", 'wb') {|f| f.write('help for _another_ non-existent role in *textile*
      ') }
  end
  
  after(:all) do
    FileUtils.remove_dir(@test_dir)
  end
  
  describe "calling find_for" do
    
    it "should fail to find extension docs with no given role type" do
      lambda { HelpDoc.find_for() }.should raise_error(ArgumentError)
    end
    
    it "should find for all users extension docs named 'HELP' with an optional file extension" do 
      lambda do 
        HelpDoc.find_for(:all).each do |doc|
          raise Exception unless /HELP(\.[\w]+)?$/.match(doc)
        end
      end.should_not raise_error(Exception)
      HelpDoc.find_for(:all).size.should > 0
    end
    
    it "should find extension docs for developers named 'HELP_developer' and end with an optional file extension" do
      lambda do
        HelpDoc.find_for(:developer).each do |doc|
          raise Exception unless /HELP_developer/.match(doc)
        end
      end.should_not raise_error(Exception)
      HelpDoc.find_for(:developer).size.should > 0
    end
    
    it "should find extension docs for admins named 'HELP_admin' and end with an optional file extension" do
      lambda do
        HelpDoc.find_for(:admin).each do |doc|
          raise Exception unless /HELP_admin(\.[\w]+)?$/.match(doc)
        end
      end.should_not raise_error(Exception)
      HelpDoc.find_for(:admin).size.should > 0
    end
    
    it "should find only the given extension's docs when given an extension name" do
      HelpDoc.find_for(:all, @test_ext_name).size.should == 1
    end
    
  end
  
  describe "calling formatted_contents_from" do
  
    it "should return formatted contents of a given extension doc in RDoc formatting by default" do
      test_doc = HelpDoc.find_for(:all, @test_ext_name).first
      HelpDoc.formatted_contents_from(test_doc).should == "<p>\nhelp for all\n</p>\n"
    end

    it "should return RDoc formatted contents of a given extension doc ending in '.rdoc'" do
      test_doc = HelpDoc.find_for(:developer, @test_ext_name).first
      HelpDoc.formatted_contents_from(test_doc).should == "<h2>Testing</h2>\n<p>\nhelp for developers in rdoc\n</p>\n"
    end

    it "should return Markdown formatted contents of a given extension doc ending in '.markdown'" do
      test_doc = HelpDoc.find_for(:admin, @test_ext_name).first
      HelpDoc.formatted_contents_from(test_doc).should == "<h2>Test</h2>\n<p>help for admins in <strong>markdown</strong></p>\n"
    end

    it "should return Markdown formatted contents of a given extension doc ending in '.md'" do
      test_doc = HelpDoc.find_for(:imaginary, @test_ext_name).first
      HelpDoc.formatted_contents_from(test_doc).should == "<h2>Test</h2>\n<p>help for non-existent role in <strong>markdown</strong></p>\n"
    end

    it "should return Textile formatted contents of a given extension doc ending in '.textile'" do
      test_doc = HelpDoc.find_for(:other, @test_ext_name).first
      HelpDoc.formatted_contents_from(test_doc).should == "<p>help for <em>another</em> non-existent role in <strong>textile</strong></p>"
    end
  
  end
  
  it "should call parsed_rdoc and return HTML from RDoc formatted text" do
    test_doc = HelpDoc.find_for(:developer, @test_ext_name).first
    HelpDoc.parsed_rdoc(test_doc).should == "<h2>Testing</h2>\n<p>\nhelp for developers in rdoc\n</p>\n"
  end
  
  it "should call parsed_markdown and return HTML from Markdown formatted text" do
    test_doc = HelpDoc.find_for(:admin, @test_ext_name).first
    HelpDoc.parsed_markdown(test_doc).should == "<h2>Test</h2>\n<p>help for admins in <strong>markdown</strong></p>\n"
  end
  
  it "should call parsed_textile and return HTML from Textile formatted text" do
    test_doc = HelpDoc.find_for(:other, @test_ext_name).first
    HelpDoc.parsed_textile(test_doc).should == "<p>help for <em>another</em> non-existent role in <strong>textile</strong></p>"
  end
    
end