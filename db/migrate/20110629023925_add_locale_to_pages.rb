class AddLocaleToPages < ActiveRecord::Migration
  def self.up
    change_table :admin_pages do |t|
      t.locale_fields
    end

    remove_index :admin_pages, :controller_path
    add_index :admin_pages, [:controller_path, :locale], :unique => true
  end

  def self.down
    remove_column :admin_pages, :locale
  end
end
