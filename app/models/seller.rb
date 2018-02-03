class Seller < ApplicationRecord
  belongs_to :group
  has_many :books
  has_secure_password
  validates :name, :rut, :password_digest, presence: true
end
