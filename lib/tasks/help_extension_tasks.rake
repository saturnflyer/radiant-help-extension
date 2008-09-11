namespace :radiant do
  desc "Shows some help information"
  task :help do
    puts %{
  Finding help for Radiant
  ========================
  The Help extension that you have installed in vendor/extensions 
  provides information about using Radiant.
  
  If you need some help with your installation, try joining the 
  Radiant email lists and ask your questions there. For information 
  visit http://radiantcms.org/mailing-list/

  You may also find help from the Radiant community in the 
  #radiantcms IRC channel on irc.freenode.net
  
  Lastly, checkout the companies listed at 
  http://wiki.radiantcms.org/Radiant_Pros
  
  Extensions
  ==========
  You may find other extensions at http://ext.radiantcms.org
  
  To install them (with Radiant version 0.6.9 or later) you may
  run 'script/extension install the_extension_name'. And if you'd 
  like more information, try 'script/extension help'
    }
  end
end
