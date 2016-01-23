class AddShipToPostings < ActiveRecord::Migration
  def change
    add_column :postings, :ship, :string
  end
end
