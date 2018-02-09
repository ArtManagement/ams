class Sale < ApplicationRecord
  belongs_to :artwork
  belongs_to :sale_slip
  has_many :sale_cancels
  has_many :receipts
end
