class Admin::HelpController < ApplicationController
  include ActiveSupport::CoreExtensions::String::Inflections

  # only_allow_access_to :index, :show, :new, :create, :edit, :update, :remove, :destroy,
  #   :when => :admin,
  #   :denied_url => { :controller => 'help', :action => 'index' },
  #   :denied_message => 'You must have administrative privileges to perform this action.'

  def index
    @role = 'all'
    @docs = HelpDoc.find_for(:all)
    @file_not_found_page = Page.find(:first, :conditions => {:class_name => 'FileNotFoundPage'})
    @layouts = Layout.find(:all)
    @filters = TextFilter.descendants.uniq
    @cms_name = Radiant::Config['admin.title']
  end
  
  def role
    @template_name = 'role'
    if params[:role].nil?
      @role = 'all'
      flash[:error] = "Sorry. I couldn't find any documentation for your request so you've been redirected to this page."
      redirect_to help_url
      return
    else
      if params[:role] == 'admin' or params[:role] == 'designer'
        @role = params[:role]
      else
        @role = 'other'
        @custom_role = params[:role]
      end
    end
    if File.exists?("#{RAILS_ROOT}/vendor/extensions/help/app/views/admin/help/_#{@role}_index.html.haml")
      @docs = HelpDoc.find_for(@role)
    else
      flash[:error] = "Information for the '#{@role}' role could not be found."
      redirect_to help_url
      return
    end
  end
  
  def developing
    
  end
  
  def extension_doc
    @template_name = 'extension_doc'
    @role = params[:role].nil? ? 'all' : params[:role]
    @docs = HelpDoc.find_for(@role)
    if params[:extension_name] != 'all'
      @doc_name = params[:extension_name].titleize
      @doc_path = HelpDoc.find_for(@role,params[:extension_name]).first
    else
      @doc_path = @docs.first
      @doc_name = @template.doc_extension_dir(@doc_path).titleize
    end
    @doc = HelpDoc.formatted_contents_from(@doc_path)
  end
end