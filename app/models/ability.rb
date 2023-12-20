# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all if user.admin?
    can %i[read create], Order if user.waiter?
    can %i[read update ready in_process dispatch_item], Order if user.cook?
  end
end
