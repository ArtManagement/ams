class Purchase < ApplicationRecord
  belongs_to :artwork
  belongs_to :purchase_slip
  has_many :purchase_cancels
  has_many :payments
  accepts_nested_attributes_for :artwork
end
