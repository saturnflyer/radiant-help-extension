ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'admin/help', :conditions => {:method => :get} do |help|
    help.developing 'admin/help/developing', :action => 'developing'
    help.help_role 'admin/help/role/:role', :action => 'role', :role => nil
    help.help_extension_doc 'admin/help/extension/:extension_name/:role', :action => 'extension_doc', :extension_name => 'all', :role => 'all'
    help.help 'admin/help', :action => 'index'
  end
end