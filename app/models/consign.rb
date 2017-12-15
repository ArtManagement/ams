class Consign < ApplicationRecord
  belongs_to :artwork
  belongs_to :consign_slip
  has_many :consign_returns
end
