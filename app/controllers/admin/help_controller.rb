class Admin::HelpController < ApplicationController
  include ActiveSupport::CoreExtensions::String::Inflections
  
  def index
    @extensions = HelpfulExtension.find(:all)
  end
  
  def show
    @sought = params[:extension_name].camelize
    @sought_constant = @sought.constantize
    @extension = HelpfulExtension.find_by_name(@sought)
    if @extension.nil?
      render :action => 'unknown'
    end
  rescue NameError
    render :action => 'unknown'
  end
  
  def unknown
  end
end