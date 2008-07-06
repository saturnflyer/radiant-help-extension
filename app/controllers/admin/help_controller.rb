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
  
  def role
    if params[:role].nil?
      @role = 'all'
      flash[:error] = "Sorry. I couldn't find any documentation for your request so you've been redirected to this page."
      redirect_to help_url
      return
    else
      @role = params[:role]
    end
    if File.exists?("#{RAILS_ROOT}/vendor/extensions/help/app/views/admin/help/_#{@role}_index.html.haml")
      @docs = HelpDoc.find_for(@role)
    else
      flash[:error] = "Information for the '#{@role}' role could not be found."
      redirect_to help_url
      return
    end
  end
  
  def extension_doc
    @role = params[:role].nil? ? 'all' : params[:role]
    @docs = HelpDoc.find_for(@role)
    @doc_name = params[:extension_name].titleize
    @doc = HelpDoc.find_for(@role,params[:extension_name]).first
  end
end