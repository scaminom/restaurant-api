# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, User if user.admin?
    can %i[read create update], Client if user.admin?
    can %i[read create], Invoice if user.admin?
    can %i[read update create dispatch_item dispatch_order distroy], Order if user.waiter?
    can %i[read occupy release], Table if user.waiter? || user.cashier?
    can %i[read update], Order if user.cashier?
    can %i[read create], Invoice if user.cashier?
    can %i[read create update], Client if user.cashier?
    can :manage, Item if user.waiter? || user.cook? || user.cashier?
    can :read, Product if user.waiter? || user.cook? || user.cashier?
    can %i[read in_process dispatch_item], Order if user.cook?
  end
end
