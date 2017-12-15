class SaleCancelSlip < ApplicationRecord
  belongs_to :customer
  has_many :sale_cancels  
end
