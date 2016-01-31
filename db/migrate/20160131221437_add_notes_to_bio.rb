class AddNotesToBio < ActiveRecord::Migration
  def change
    add_column :bios, :notes, :string
  end
end
