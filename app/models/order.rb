class Order < ApplicationRecord
  has_many :order_items
  belongs_to :user

  validates :user_id, presence: true
  validates :total_price, presence: true
  validates :total_price, numericality: { greater_than: 0 }

  def to_string
    "#{id} | #{user_id} | #{delivered_at} | #{total_price}"
  end

  def self.pending_orders
    all.where(delivered_at: nil)
  end
end
