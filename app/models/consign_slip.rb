class ConsignSlip < ApplicationRecord
  belongs_to :customer
  has_many :consigns  
end
