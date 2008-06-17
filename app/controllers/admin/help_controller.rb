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
    @rdocs = HelpRdoc.find(:all)
    @file_not_found_page = Page.find(:first, :conditions => {:class_name => 'FileNotFoundPage'})
    @layouts = Layout.find(:all)
    @filters = TextFilter.descendants.uniq
    @cms_name ||= Radiant::Config['admin.title']
    @extensions = HelpfulExtension.find(:all)
  end
  
  def show
    @sought = params[:extension_name].camelize
    @sought_constant = @sought.constantize
    @rdocs = HelpRdoc.find(:all)
    @extensions = HelpfulExtension.find(:all)
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
  
  def docs
    @rdocs = HelpRdoc.find(:all)
    @extensions = HelpfulExtension.find(:all)
    @rdoc = HelpRdoc.find(:all, params[:extension_name])
  end
  
  def unknown
  end
  
  def developing
    @rdocs = HelpRdoc.find(:developer)
    render :template => 'admin/help/developing/index.html.haml'
  end
  
  def developing_docs
    render :action => 'developing' if params[:extension_name].nil?
    @rdocs = HelpRdoc.find(:developer)
    @rdoc = HelpRdoc.find(:developer, params[:extension_name])
    render :template => 'admin/help/developing/docs.html.haml'
  end
  
  def administering
    @cms_name ||= Radiant::Config['admin.title']
    @rdocs = HelpRdoc.find(:admin)
    render :template => 'admin/help/administering/index.html.haml'
  end
  
  def administering_docs
    render :action => 'administering' if params[:extension_name].nil?
    @rdocs = HelpRdoc.find(:admin)
    @rdoc = HelpRdoc.find(:admin, params[:extension_name])
    render :template => 'admin/help/administering/docs.html.haml'
  end
end