class Technique < ApplicationRecord
  belongs_to :category
  has_many :artworks
end
