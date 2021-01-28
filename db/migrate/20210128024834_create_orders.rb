class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.bigint :user_id
      t.date :delivered_at
      t.integer :total_price
      t.timestamps
    end
  end
end
