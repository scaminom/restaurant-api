class Order < ApplicationRecord
  belongs_to :table
  belongs_to :waiter, class_name: 'User', foreign_key: 'waiter_id'
end
