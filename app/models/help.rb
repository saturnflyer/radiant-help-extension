class Help < ActiveRecord::Base
  belongs_to :helpful_extension
  acts_as_tree
  
  validates_presence_of :helpful_extension_id
  validates_presence_of :topic
  validates_uniqueness_of :topic, :scope => [:helpful_extension_id, :parent_id]
end
