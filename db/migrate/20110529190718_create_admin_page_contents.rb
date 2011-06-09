class CreateAdminPageContents < ActiveRecord::Migration
  def self.up
    create_table :admin_page_contents do |t|
      t.references :page
      t.string :key
      t.text :content

      t.timestamps
    end

    add_index :admin_page_contents, :page_id
    add_index :admin_page_contents, [:page_id, :key], :unique => true
  end

  def self.down
    drop_table :admin_page_contents
  end
end
