class CreateAdminPages < ActiveRecord::Migration
  def self.up
    create_table :admin_pages do |t|
      t.string :controller_path
      t.string :title
      t.string :description
      t.string :keywords

      t.timestamps
    end

    add_index :admin_pages, :controller_path, :unique => true
  end

  def self.down
    drop_table :admin_pages
  end
end
