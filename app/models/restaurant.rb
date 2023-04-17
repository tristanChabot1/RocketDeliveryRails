class Restaurant < ApplicationRecord
  belongs_to :user
  belongs_to :address

  has_many :orders
  has_many :products

  validates :user, presence: { message: "can't be blank" }
  validates :address, presence: { message: "can't be blank" }
  validates :active, presence: { message: "can't be blank" }

  validates :phone, presence: true
  validates :name, presence: true
  validates :price_range, presence: true

end
