class Group < ApplicationRecord
  belongs_to :institution
  has_many :sellers
end
