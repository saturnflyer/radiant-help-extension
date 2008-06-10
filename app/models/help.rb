class Help < ActiveRecord::Base
  belongs_to :helpful_extension
  has_one :parent, :class_name => 'Help', :foreign_key => 'parent_id'
  
  validates_uniqueness_of :topic, :scope => [:helpful_extension_id, :parent_id]
end
