class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :menu_item

  validates :menu_item_id, presence: true
  validates :user_id, presence: true
  validates :qty, presence: true
  validates :qty, numericality: { greater_than: 0 }

  def self.of_user(id)
    all.where(user_id: id).order(:created_at)
  end

  def to_string
    "ID : #{id} | MENU ITEM : #{menu_item_id} | USER : #{user_id} | QTY : #{qty}"
  end

  def self.add_to_cart(menu_item_id, user_id, qty = 1)
    puts "#{menu_item_id}#{user_id}#{qty}"
    menu_item = of_user(user_id).where("menu_item_id = ?", menu_item_id).first
    if menu_item
      menu_item.qty = qty
      return menu_item
    else
      new_cart = Cart.new({ menu_item_id: menu_item_id, user_id: user_id, qty: qty })
      pp new_cart
      return new_cart
    end
  end
end
