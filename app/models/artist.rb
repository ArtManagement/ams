class Artist < ApplicationRecord
  belongs_to :artist_class
  belongs_to :nationality
  has_many :artworks
end
