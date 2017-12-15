class SaleSlip < ApplicationRecord
  belongs_to :customer
  has_many :sales
end
