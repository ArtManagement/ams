class TrustReturn < ApplicationRecord
  belongs_to :trust
  belongs_to :trust_return_slip
end
