class Customer < ApplicationRecord
  belongs_to :user
  belongs_to :address

  validates :phone, presence: true
  validates :active, presence: true

  validates :user, presence: { message: "can't be blank" }
  validates :address, presence: { message: "can't be blank" }

  has_many :orders

end
