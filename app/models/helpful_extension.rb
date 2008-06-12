class HelpfulExtension < ActiveRecord::Base
  
  class DetailsError < ArgumentError; end
  
  has_many :helps, :dependent => :delete_all
  
  validates_presence_of :name
  
  # Provide these details for your extension:
  #  :name (required)
  #  :author_name 
  #  :author_contact
  def self.register(options = {})
    details = options
    raise HelpfulExtension::DetailsError, "You must provide a :name for your HelpfulExtension." if details[:name].nil?
    failed_atts = {}
    helper = self.find_or_create_by_name(details[:name])
    details.each do |method,value|
      unless self.method_defined?(method)
        failed_atts[method.to_sym] = value
      end
    end
    raise HelpfulExtension::DetailsError, "Setting #{failed_atts.inspect} does not work with HelpfulExtension. Check your attributes and try again." unless failed_atts.blank?
    helper.update_attributes(details)
    puts helper.inspect
    # helper.save
    helper
  end
  
  # Removes the extension information from the help tables.
  def self.unregister(extension_name)
    helper = self.find_by_name(extension_name) if extension_name.kind_of?(String)
    helper = self.find_by_name(extension_name.name) if extension_name.respond_to?(:name)
    helper.destroy unless helper.nil?
  end
end