class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: { message: "can't be blank" }

  has_one :employee
  has_one :customer
  has_one :courier

  has_many :restaurants

end
