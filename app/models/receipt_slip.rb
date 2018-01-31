class ReceiptSlip < ApplicationRecord
  belongs_to :customer
  has_many :receipts
end
