class Admin::HelpController < ApplicationController
  include ActiveSupport::CoreExtensions::String::Inflections
  
  def index
    @role = 'all'
    @docs = HelpDoc.find_for(:all)
    @file_not_found_page = Page.find(:first, :conditions => {:class_name => 'FileNotFoundPage'})
    @layouts = Layout.find(:all)
    @filters = TextFilter.descendants.uniq
    @cms_name = Radiant::Config['admin.title']
  end
  
  def show
    @role = params[:role].nil? ? 'all' : params[:role]
    @sought = params[:extension_name].camelize
    @sought_constant = @sought.constantize
    @docs = HelpDoc.find_for(:all)
    @helps = nil
    render :action => 'unknown'
  rescue NameError
    render :action => 'unknown'
  end
  
  def unknown
  end
  
  def role
    if params[:role].nil?
      @role = 'all'
      flash[:error] = "Sorry. I couldn't find any documentation for your request so you've been redirected to this page."
      redirect_to help_url
    else
      @role = params[:role]
    end
    @docs = HelpDoc.find_for(@role)
  end
  
  def extension_doc
    @role = params[:role].nil? ? 'all' : params[:role]
    @docs = HelpDoc.find_for(@role)
    @doc_name = params[:extension_name].titleize
    @doc = HelpDoc.find_for(@role,params[:extension_name]).first
  end
end