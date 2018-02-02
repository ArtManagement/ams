class ExhibitSlip < ApplicationRecord
  belongs_to :customer
  has_many :exhibits
end
