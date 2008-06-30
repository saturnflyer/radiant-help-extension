require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HelpController do
  # use Radiant scenarios
  scenario :users
  
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
      Radiant::Config.stub!(:[]).with('admin.title').and_return('Test CMS')
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
      # Page.stub!(:find).with(:first).with(:conditions)#.and_return(@page404)
      get :index
      assigns[:file_not_found_page] == @page404
    end
  end
end