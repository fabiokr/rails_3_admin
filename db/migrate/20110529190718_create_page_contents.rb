class CreatePageContents < ActiveRecord::Migration
  def self.up
    create_table :page_contents do |t|
      t.references :page
      t.string :key
      t.text :content

      t.timestamps
    end

    add_index :page_contents, :page_id
    add_index :page_contents, [:page_id, :key], :unique => true
  end

  def self.down
    drop_table :page_contents
  end
end
