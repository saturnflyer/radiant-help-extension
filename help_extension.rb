# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'
# You'll need this if you are going to add regions into your extension interface.
require 'ostruct'

class HelpExtension < Radiant::Extension
  version "1.0"
  description "Help Documentation for Radiant CMS"
  url "http://saturnflyer.com/"
  
  define_routes do |map|
    map.with_options :controller => 'admin/help' do |help|
      help.help 'admin/help', :action => 'index', :conditions => {:method => :get}
      help.help_developing 'admin/help/developing', :action => 'developing', :conditions => {:method => :get}
      help.help_administering 'admin/help/administering', :action => 'administering', :conditions => {:method => :get}
      help.connect 'admin/help/:extension_name', :action => 'show', :conditions => {:method => :get}
    end
  end
  
  def activate
    admin.tabs.add "Help", "/admin/help", :after => "Layouts", :visibility => [:all]
    
    # admin.page.edit.add :main, "user_help_toggle", :before => "edit_header" 
    
    # This adds information to the Radiant interface. In this extension, we're dealing with "help" views
    # so :help is an attr_accessor. If you're creating an extension for tracking moons and stars, you might
    # put attr_accessor :moon, :star
    Radiant::AdminUI.class_eval do
      attr_accessor :help
    end
    # initialize regions for help (which we created above)
    admin.help = load_default_help_regions
  end
  
  def deactivate
  end
  
  private
  
  # This is where we define all of the regions to be used in the views and partials
  def load_default_help_regions
    returning OpenStruct.new do |help|
      help.index = Radiant::AdminUI::RegionSet.new do |index|
        index.main.concat %w{introduction organizing editing}
        index.filter.concat %w{filter_basics}
        index.developer.concat %w{developer_layouts}
        index.admin.concat %w{admin_users}
        index.additional.concat %w{features_introduction}
      end
      help.show = Radiant::AdminUI::RegionSet.new do |show|
        # show.
      end
    end
  end
  
end