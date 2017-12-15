class PurchaseCancel < ApplicationRecord
  belongs_to :purchase
  belongs_to :purchase_cancel_slip
end
