class Receipt < ApplicationRecord
  belongs_to :sale
  belongs_to :receipt_slip
end
