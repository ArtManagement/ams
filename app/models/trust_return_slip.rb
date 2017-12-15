class TrustReturnSlip < ApplicationRecord
  belongs_to :customer
  has_many :trust_returns
end
