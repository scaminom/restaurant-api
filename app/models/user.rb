class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable

  has_many :orders, foreign_key: 'waiter_id'
  has_many :events

  enum role: {
    'guess': 0,
    'cook': 1,
    'waiter': 2,
    'cashier': 3
  }
end
