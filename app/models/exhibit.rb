class Exhibit < ApplicationRecord
  belongs_to :artwork
  belongs_to :exhibit_slip
end
