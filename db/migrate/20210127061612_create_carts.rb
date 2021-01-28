class CreateCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :carts do |t|
      t.bigint :menu_item_id
      t.bigint :user_id
      t.integer :qty
      t.timestamps
    end
  end
end
