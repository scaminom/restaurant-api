# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all if user.admin?
    can %i[read update create dispatch_item dispatch_order distroy], Order if user.waiter?
    can %i[read update], Table if user.waiter?
    can :manage, Item if user.waiter? || user.cook?
    can :manage, Product if user.waiter? || user.cook?
    can %i[read in_process dispatch_item], Order if user.cook?
  end
end
