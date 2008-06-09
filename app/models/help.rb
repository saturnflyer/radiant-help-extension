class Help < ActiveRecord::Base
  belongs_to :extension_meta, :class_name => 'Radiant::ExtensionMeta'
  has_one :parent, :class_name => 'Help', :foreign_key => 'parent_id'
end
