# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'
# You'll need this if you are going to add regions into your extension interface.
require 'ostruct'
# These are needed for parsing the HELP.rdoc files
require 'rdoc/markup/simple_markup'
require 'rdoc/markup/simple_markup/to_html'

class HelpExtension < Radiant::Extension
  version "1.0"
  description "Help Documentation for Radiant CMS"
  url "http://saturnflyer.com/"
  
  # These routes are added to the radiant routes file and works just like any rails routes.
  define_routes do |map|
    map.with_options :controller => 'admin/help', :conditions => {:method => :get} do |help|
      help.help_role 'admin/role_help/:role', :action => 'role', :role => nil
      help.help_extension_doc 'admin/extension_help/:extension_name/:role', :action => 'extension_doc', :role => 'all'
      help.help 'admin/help', :action => 'index'
    end
  end
  
  def activate
    # This adds a tab to the interface after the Layouts tab, and allows all users to access it.
    admin.tabs.add "Help", "/admin/help", :after => "Layouts", :visibility => [:all]
    
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
    
    # Finally, allow all the helpers to be used anywhere
    ApplicationController.class_eval {
      helper Admin::HelpHelper
    }
  end
  
  def deactivate
    # This never happens
  end
  
  private
  
  # This is where we define all of the regions to be used in the views and partials
  def load_default_help_regions
    returning OpenStruct.new do |help|
      help.index = Radiant::AdminUI::RegionSet.new do |index|
        index.main.concat %w{introduction organizing editing}
        index.page_details.concat %w{page_details_introduction slug breadcrumb}
        index.filter.concat %w{filter_basics}
        index.available_tags.concat %w{available_tags_basics}
        index.layout.concat %w{layout_basics}
        index.page_type.concat %w{page_type_basics}
        index.saving.concat %w{saving_basics}
        index.extras.concat %w{extension_docs_list}
      end
      help.role = Radiant::AdminUI::RegionSet.new do |role|
        role.extras.concat %w{extension_docs_list regions}
        role.regions.concat %w{regions_introduction}
      end
      help.extension_doc = Radiant::AdminUI::RegionSet.new do |extension_doc|
        extension_doc.extras.concat %w{extension_docs_list}
      end
    end
  end
  
end