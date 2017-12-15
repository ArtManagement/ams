class SaleCancel < ApplicationRecord
  belongs_to :sale
  belongs_to :sale_cancel_slip
end
