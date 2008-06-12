class Help < ActiveRecord::Base
  belongs_to :helpful_extension
  acts_as_tree
  
  validates_uniqueness_of :topic, :scope => [:helpful_extension_id, :parent_id]
end
