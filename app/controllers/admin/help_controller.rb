class Admin::HelpController < ApplicationController
  include ActiveSupport::CoreExtensions::String::Inflections
  
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
end