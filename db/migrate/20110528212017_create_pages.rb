class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :controller_path
      t.string :title
      t.string :description
      t.string :tags

      t.timestamps
    end

    add_index :pages, :controller_path, :unique => true
  end

  def self.down
    drop_table :pages
  end
end
