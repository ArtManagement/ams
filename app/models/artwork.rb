class Artwork < ApplicationRecord
  belongs_to :artist
  belongs_to :size
  belongs_to :size_unit
  belongs_to :category
  belongs_to :technique
  belongs_to :format
  belongs_to :motif
  has_many :purchases
  has_many :trusts
  has_many :sales
  has_many :consigns
  has_many :exhibits
  has_one :image
end
