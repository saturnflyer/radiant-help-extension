require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HelpController do
  # use Radiant datasets
  dataset :users
  
  before(:each) do
    login_as :existing
  end
  
  describe "calling index with GET" do
    it "should render the index template" do
      get :index
      response.should render_template('admin/help/index')
    end
    
    it "should assign HelpDocs for all users" do
      @doc = "/path/to/doc/HELP.rdoc"
      HelpDoc.stub!(:find_for).with(:all).and_return([@doc])
      get :index
      assigns[:docs].should == [@doc]
    end
    
    it "should set the role to 'all' and assign it to the view" do
      get :index
      assigns[:role].should == 'all'
    end
    
    it "should get the cms_name from Radiant::Config and assign it to the view" do
      Radiant::Config.stub!(:[],'admin.title').and_return('Test CMS')
      get :index
      assigns[:cms_name].should == 'Test CMS'
    end
    
    it "should find all TextFilters and assign them to the view" do
      TextFilter.stub!(:descendants).and_return([MarkdownFilter, TextileFilter])
      get :index
      assigns[:filters].should == [MarkdownFilter, TextileFilter]
    end
    
    it "should find all Layouts and assign them to the view" do
      @layout1 = mock_model(Layout)
      Layout.stub!(:find).with(:all).and_return([@layout1])
      get :index
      assigns[:layouts].should == [@layout1]
    end
    
    it "should find the first FileNotFoundPage and assign it to the view" do
      @page404 = mock_model(Page, :class_name => 'FileNotFoundPage')
      Page.should_receive(:find).with(:first,{:conditions => {:class_name => 'FileNotFoundPage'}}).and_return(@page404)
      get :index
      assigns[:file_not_found_page].should == @page404
    end
  end
  
  describe "calling extension_doc with GET" do
    it "should load the role from the params and assign it to the view" do
      get :extension_doc, :extension_name => 'help', :role => 'developer'
      assigns[:role].should == 'developer'
    end
    
    it "should set the role to 'all' if none is present in the params and assign it to the view" do
      @test_path = '/path'
      HelpDoc.stub!(:find_for).and_return([@test_path])
      File.stub!(:read).and_return('') # can't read a non-existant path
      get :extension_doc, :extension_name => 'help'
      assigns[:role].should == 'all'
    end
    
    it "should find all HelpDocs for the given role and assign them to the view" do
      @doc1 = "/path/to/test1/HELP_admin.rdoc"
      @doc2 = "/path/to/test2/HELP_admin.rdoc"
      File.stub!(:read).and_return('') # can't read a non-existant path
      HelpDoc.should_receive(:find_for).with("admin").and_return([@doc1,@doc2])
      HelpDoc.stub!(:find_for).with("admin","test1").and_return([@doc1])
      get :extension_doc, :extension_name => 'test1', :role => 'admin'
      assigns[:docs].should == [@doc1,@doc2]
    end
    
    it "should get the doc_name from the URL extension_name and assign it to the view" do
      get :extension_doc, :extension_name => 'help', :role => 'developer'
      assigns[:doc_name].should == 'Help'
    end
    
    it "should find the HelpDoc for the given role and extension_name" do
      @doc1 = "/path/to/test1/HELP_developer.rdoc"
      @doc2 = "/path/to/test2/HELP_developer.rdoc"
      File.stub!(:read).and_return('') # can't read a non-existant path
      HelpDoc.stub!(:find_for).with("developer").and_return([@doc1,@doc2])
      HelpDoc.should_receive(:find_for).with("developer","test1").and_return([@doc1])
      get :extension_doc, :extension_name => 'test1', :role => 'developer'
      assigns[:doc_path].should == @doc1
    end
  end
  
  describe "calling role with GET" do
    it "should find the HelpDocs for the given role and assign them to the view" do
      @doc1 = "/path/to/test1/HELP_admin.rdoc"
      @doc2 = "/path/to/test2/HELP_admin.rdoc"
      HelpDoc.should_receive(:find_for).with("admin").and_return([@doc1,@doc2])
      get :role, :role => 'admin'
      assigns[:docs].should == [@doc1,@doc2]
    end
    
    it "should redirect to the help index if given no role" do
      get :role
      response.should redirect_to(:action => 'index')
    end
  end
end