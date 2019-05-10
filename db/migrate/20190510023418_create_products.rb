class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.text :name
      t.text :image
      t.text :description
      t.text :size
      t.text :color
      t.integer :price
      t.integer :stock
      t.text :classification
      t.text :pet_type

      t.timestamps
    end
  end
end
