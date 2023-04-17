class Courier < ApplicationRecord
  belongs_to :user
  belongs_to :address
  belongs_to :courier_status

  validates :active, presence: true

  validates :user, presence: { message: "can't be blank" }
  validates :address, presence: { message: "can't be blank" }
  validates :courier_status, presence: { message: "can't be blank" }

  has_many :orders
end
