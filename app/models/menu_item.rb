class MenuItem < ApplicationRecord
  belongs_to :menu

  validates :menu_id, presence: true
  validates :name, presence: true
  validates :name, length: { minimum: 2 }
  validates :description, presence: true
  validates :description, length: { minimum: 3 }
  validates :image, presence: true
  validates :image, length: { minimum: 3 }
  validates :price, presence: true
  validates :prep_time, presence: true
  validates :prep_time, numericality: { greater_than: 0 }
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :is_veg, inclusion: { in: [true, false] }

  def self.of_menu(id)
    all.where(menu_id: id)
  end

  def self.get_active
    MenuItem.of_menu(Menu.get_active.id)
  end

  def to_string
    "#{id}| #{menu_id} | #{name} | #{description} | #{price}"
  end
end
