class CreateHelpfulExtensions < ActiveRecord::Migration
  def self.up
    create_table :helpful_extensions do |t|
      t.string :name, :author_name, :author_contact

      t.timestamps
    end
  end

  def self.down
    drop_table :helpful_extensions
  end
end
