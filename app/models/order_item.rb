class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :menu_item

  validates :order_id, presence: true
  validates :menu_item_id, presence: true
  validates :menu_item_name, presence: true
  validates :menu_item_price, presence: true
  validates :qty, presence: true

  def to_string
    "#{id} | #{order_id} | #{menu_item_id} | #{menu_item_name} | #{menu_item_price} | #{qty}"
  end

  def self.of_order(id)
    all.where(order_id: id)
  end
end
