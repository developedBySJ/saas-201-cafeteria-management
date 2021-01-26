class Menu < ApplicationRecord
  has_many :menu_items

  validates :name, presence: true
  validates :name, length: { minimum: 2 }
  validates :is_active, inclusion: { in: [true, false] }

  before_save :ensure_one_active

  def to_string
    "#{id} | #{name} | #{is_active}"
  end

  def get_menu_items
    MenuItem.of_menu(id)
  end

  def activate!
    self.is_active = true
    save
  end

  def ensure_one_active
    if self.is_active && changed.has_key?(:is_active)
      update_attribute(:is_active, false)
    end
  end
end
