class PurchaseCancelSlip < ApplicationRecord
  belongs_to :customer
  has_many :purchase_cancels
end
