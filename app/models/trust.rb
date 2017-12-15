class Trust < ApplicationRecord
  belongs_to :artwork
  belongs_to :trust_slip
  has_many :trust_returns
end
