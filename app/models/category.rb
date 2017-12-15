class Category < ApplicationRecord
  has_many :artworks
  has_many :techniques
end
