class Book < ApplicationRecord
  belongs_to :seller
  has_many :tickets
end
