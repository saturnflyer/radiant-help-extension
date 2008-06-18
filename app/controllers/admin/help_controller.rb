class Admin::HelpController < ApplicationController
  include ActiveSupport::CoreExtensions::String::Inflections
  
  def index
    @role = params[:role].nil? ? 'all' : params[:role]
    @rdocs = HelpRdoc.find(:all)
    @file_not_found_page = Page.find(:first, :conditions => {:class_name => 'FileNotFoundPage'})
    @layouts = Layout.find(:all)
    @filters = TextFilter.descendants.uniq
    @cms_name ||= Radiant::Config['admin.title']
    @extensions = HelpfulExtension.find(:all)
  end
  
  def show
    @role = params[:role].nil? ? 'all' : params[:role]
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
  
  def unknown
  end
  
  def role
    @role = params[:role].nil? ? 'all' : params[:role]
    @rdocs = HelpRdoc.find(@role)
    @extensions = HelpfulExtension.find(:all)
  end
  
  def extension_doc
    @role = params[:role].nil? ? 'all' : params[:role]
    @rdocs = HelpRdoc.find(@role)
    @rdoc_name = params[:extension_name].titleize
    @rdoc = HelpRdoc.find(@role,params[:extension_name])
    @extensions = HelpfulExtension.find(:all)
  end
end