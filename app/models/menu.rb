class Menu < ApplicationRecord
  has_many :menu_items, :dependent => :destroy

  validates :name, presence: true
  validates :name, length: { minimum: 2 }
  validates :is_active, inclusion: { in: [true, false] }

  before_save :ensure_one_active
  after_destroy :after_delete

  def to_string
    "#{id} | #{name} | #{is_active}"
  end

  def get_menu_items
    MenuItem.of_menu(id)
  end

  def self.options
    all.map { |menu| [menu.name, menu.id] }
  end
  def self.get_active
    Menu.where(is_active: true).first
  end

  def activate!
    self.is_active = true
    save
  end

  def ensure_one_active
    if self.is_active && changed.include?("is_active")
      Menu.where(:is_active => true).update_all(:is_active => false)
    end
  end

  def after_delete
    if Menu.count < 2
      Menu.all.first.activate!
    end
  end
end
