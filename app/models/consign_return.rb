class ConsignReturn < ApplicationRecord
  belongs_to :consign
  belongs_to :consign_return_slip
end
