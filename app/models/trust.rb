class Trust < ApplicationRecord
  belongs_to :artwork
  belongs_to :trust_slip
  has_many :trust_returns
  accepts_nested_attributes_for :artwork
end
