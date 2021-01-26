class MenuItem < ApplicationRecord
  belongs_to :menu

  validates :menu_id, presence: true
  validates :name, presence: true
  validates :name, length: { minimum: 2 }
  validates :description, presence: true
  validates :description, length: { minimum: 3 }
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  def self.of_menu(id)
    all.where(menu_id: id)
  end

  def get_active_menu
  end

  def to_string
    "#{id}| #{menu_id} | #{name} | #{description} | #{price}"
  end
end
