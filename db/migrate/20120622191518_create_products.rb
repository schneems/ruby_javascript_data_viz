class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :user
      t.string :name
      t.integer :price

      t.timestamps
    end
    add_index :products, :user_id
  end
end
