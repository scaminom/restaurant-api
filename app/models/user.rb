class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  WHITELISTED_ATTRIBUTES = %i[
    username
    email
    password
    role
    first_name
    last_name
  ].freeze

  enum role: {
    'admin': 1,
    'cook': 2,
    'waiter': 3
  }

  def jwt_payload
    super
  end
end

