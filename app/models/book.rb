class Book < ApplicationRecord
  belongs_to :seller
  has_many :tickets
  validates :num_in_institution, presence: true
end
