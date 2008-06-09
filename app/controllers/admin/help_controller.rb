class Admin::HelpController < ApplicationController
  def index
    @extensions = Radiant::ExtensionMeta.find(:all)
  end
  
  def show
    @help = Help.find_by_topic(params[:topic])
  end
end