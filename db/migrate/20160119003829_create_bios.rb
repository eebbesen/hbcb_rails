class CreateBios < ActiveRecord::Migration
  def change
    create_table :bios do |t|
      t.text :name
      t.text :parish
      t.text :entered_service
      t.text :dates
      t.text :filename

      t.timestamps null: false
    end
  end
end
