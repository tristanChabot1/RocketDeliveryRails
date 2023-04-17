class Address < ApplicationRecord
  belongs_to :restaurant, optional: true
  has_many :customers
  has_many :employees
  has_many :couriers

  validates :street_address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
end
