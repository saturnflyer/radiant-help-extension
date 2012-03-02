# Help

This extension provides documentation for Radiant and any 
installed extensions.

Installing Help is as easy as any other Radiant extension. 
Drop it into your vendor/extensions directory.

Once the extension is installed, you must ensure that your 
application will load the Help extension before loading any 
extensions that rely on the help regions. To do so, edit 
your config/environment.rb to load Help first:

    Radiant::Initializer.run do |config|
      #...
    	config.extensions = [ :help, :all ] 
      #...
    end

Help provides basic information for the average user at 
admin/help, but also provides documentation for tasks and 
features available to developers and admins at 
`admin/help_role/developer` and `admin/help_role/admin`. 
Additionally, any extensions loaded with HELP files may be 
found at `/admin/help_extension/:extension_name/:role` but a 
list of links is automatically generated for your clicking 
pleasure.

For more information about developing for Help, install it 
and go to `/admin/help_extension/help/developer` or read the 
included `HELP_developer.rdoc`

Some content taken from http://radiantcms.org/

[Built by Saturn Flyer](http://www.saturnflyer.com)