class User < ApplicationRecord
  enum role: [:admin, :customer, :clerk]
  # has_many :orders
  has_secure_password

  validates :first_name, presence: true
  validates :first_name, length: { minimum: 2 }
  validates :last_name, presence: true
  validates :last_name, length: { minimum: 2 }
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true
  validates :password_digest, length: { minimum: 6 }
  validates :role, inclusion: { in: role.keys }

  def to_string
    "#{id} | #{first_name} | #{email} | #{role}"
  end
end
