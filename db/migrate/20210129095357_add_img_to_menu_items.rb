class AddImgToMenuItems < ActiveRecord::Migration[6.1]
  def change
    add_column :menu_items, :image, :string
    add_column :menu_items, :prep_time, :integer
    add_column :menu_items, :is_veg, :boolean
  end
end
