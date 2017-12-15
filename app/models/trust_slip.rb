class TrustSlip < ApplicationRecord
  belongs_to :customer
  has_many :trusts
end
