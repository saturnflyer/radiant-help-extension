class CreateHelps < ActiveRecord::Migration
  def self.up
    create_table :helps do |t|
      t.integer :extension_meta_id
      t.integer :parent_id
      t.string :topic
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :helps
  end
end
