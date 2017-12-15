class Customer < ApplicationRecord
  belongs_to :customer_class
  belongs_to :Prefecture
  has_many :purchase_slips
  has_many :sale_slips
end
