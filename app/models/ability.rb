class Ability
  include CanCan::Ability
  def initialize(user)
    if user && user.admin?
      can :manage, :all
      can :access, :rails_admin
    else
      can :read, :all
    end
  end
end
