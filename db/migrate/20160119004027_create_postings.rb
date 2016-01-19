class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.text :years
      t.text :position
      t.text :post
      t.text :district
      t.text :hbca_reference

      t.timestamps null: false
    end
  end
end
