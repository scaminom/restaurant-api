# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all if user.admin?
    can %i[read create dispatch_item dispatch_order], Order if user.waiter?
    # can %i[read], Event if user.waiter?
    can %i[read update in_process dispatch_item], Order if user.cook?
  end
end
