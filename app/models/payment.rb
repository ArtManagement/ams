class Payment < ApplicationRecord
  belongs_to :purchase
  belongs_to :payment_slip
end
