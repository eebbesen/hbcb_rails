class AddNamesToBio < ActiveRecord::Migration
  def change
    add_column :bios, :first_name, :string
    add_column :bios, :middle_name, :string
    add_column :bios, :last_name, :string
  end
end
