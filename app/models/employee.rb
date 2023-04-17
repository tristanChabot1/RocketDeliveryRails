class Employee < ApplicationRecord
  belongs_to :user
  belongs_to :address

  validates :phone, presence: true

  validates :user, presence: { message: "can't be blank" }
  validates :address, presence: { message: "can't be blank" }

end
