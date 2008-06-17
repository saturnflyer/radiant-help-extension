# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'
# You'll need this if you are going to add regions into your extension interface.
require 'ostruct'

class HelpExtension < Radiant::Extension
  version "1.0"
  description "Help Documentation for Radiant CMS"
  url "http://saturnflyer.com/"
  
  define_routes do |map|
    map.with_options :controller => 'admin/help', :conditions => {:method => :get} do |help|
      help.help 'admin/help', :action => 'index'
      help.help_developing 'admin/help/developing', :action => 'developing'
      help.help_developing_docs 'admin/help/developing/docs/:extension_name', :action => 'developing_docs'
      help.help_administering 'admin/help/administering', :action => 'administering'
      help.help_administering_docs 'admin/help/administering/docs/:extension_name', :action => 'administering_docs'
      help.help_docs 'admin/help/docs/:extension_name', :action => 'docs'
      help.help_extension 'admin/help/:extension_name', :action => 'show'
    end
  end
  
  def activate
    admin.tabs.add "Help", "/admin/help", :after => "Layouts", :visibility => [:all]
    
    # Future ability to toggle inline help, not yet implemented
    # admin.page.edit.add :main, "user_help_toggle", :before => "edit_header" 
    
    # This adds information to the Radiant interface. In this extension, we're dealing with "help" views
    # so :help is an attr_accessor. If you're creating an extension for tracking moons and stars, you might
    # put attr_accessor :moon, :star
    Radiant::AdminUI.class_eval do
      attr_accessor :help
    end
    
    # initialize regions for help (which we created above)
    admin.help = load_default_help_regions
    
    # Provide the ability to replace regions...
    # Don't like how the regions are setup? Hack it without changing this extension's code
    # Be forewarned, this allows you to completely change the UI
    Radiant::AdminUI::RegionSet.class_eval do
      def replace(region=nil, partial=nil)
        raise ArgumentError, "You must specify a region and a partial" unless region and partial
        self[region].replace([partial])
      end
    end
    # You could, for example create your own role based interface with this
    # admin.help.main.replace('main','main_for_admins_only')
    # But I only threw this in here to allow you to change the help docs easily if you want.
    # I am merely providing the rope...
  end
  
  def deactivate
    # This never happens
    # TODO: look into ideas like mixology to bring this back http://www.somethingnimble.com/bliki/mixology
  end
  
  private
  
  # This is where we define all of the regions to be used in the views and partials
  def load_default_help_regions
    returning OpenStruct.new do |help|
      help.index = Radiant::AdminUI::RegionSet.new do |index|
        index.main.concat %w{introduction organizing editing}
        index.filter.concat %w{filter_basics}
        index.additional.concat %w{features_introduction}
        index.rdocs.concat %w{rdocs_introduction}
        index.rdocs_administering.concat %w{rdocs_administering_introduction}
      end
      help.show = Radiant::AdminUI::RegionSet.new do |show|
        # show.
      end
      help.developing = Radiant::AdminUI::RegionSet.new do |developing|
        developing.rdocs_developing.concat %w{rdocs_developing_introduction}
      end
      help.adminsistering = Radiant::AdminUI::RegionSet.new do |adminsistering|
        adminsistering.rdocs_administering.concat %w{rdocs_developing_introduction}
      end
    end
  end
  
end