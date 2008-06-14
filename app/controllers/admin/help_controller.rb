class Admin::HelpController < ApplicationController
  include ActiveSupport::CoreExtensions::String::Inflections
  
  only_allow_access_to :developing,
    :when => [:developer, :admin],
    :denied_url => { :controller => 'help', :action => 'index' },
    :denied_message => 'You must have developer privileges to access this information.'
  
  only_allow_access_to :administering,
    :when => :admin,
    :denied_url => { :controller => 'help', :action => 'index' },
    :denied_message => 'You must have admin privileges to access this information.'
  
  def index
    @file_not_found_page = Page.find(:first, :conditions => {:class_name => 'FileNotFoundPage'})
    @layouts = Layout.find(:all)
    @filters = TextFilter.descendants.uniq
    @name ||= Radiant::Config['admin.title']
    @extensions = HelpfulExtension.find(:all)
  end
  
  def show
    @sought = params[:extension_name].camelize
    @sought_constant = @sought.constantize
    @extension = HelpfulExtension.find_by_name(@sought)
    unless @extension.nil?
      @helps = @extension.helps.find(:all, :conditions => {:parent_id => nil})
    else
      @helps = nil
      render :action => 'unknown'
    end
  rescue NameError
    render :action => 'unknown'
  end
  
  def unknown
  end
  
  def developing
    render :template => 'admin/help/developing/index.html.haml'
  end
  
  def administering
    render :template => 'admin/help/administering/index.html.haml'
  end
end