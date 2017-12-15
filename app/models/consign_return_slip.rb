class ConsignReturnSlip < ApplicationRecord
  belongs_to :customer
  has_many :consign_returns
end
