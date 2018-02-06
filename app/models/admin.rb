class Admin < ApplicationRecord
  belongs_to :institution
  has_secure_password
end
