class Ability
  include CanCan::Ability

  attr_reader :actors

  def initialize(user)
    @user = user || User.new # guest user (not logged in)

    if @user.admin?
      can :manage, :all
    else
      can :manage, [Song, SongRole, Routine, RoutineRole, Play] do |obj|
        user_is_in_owner_users? obj.owner
      end

      can :read, Song do |song|
        # can probably extract admin_users and admin_groups check for reuse
        song.everyone? || user_or_actors_are_admin?(song)
      end
    end
  end

  def user_is_in_owner_users?(owner)
    owner.users.include? @user
  end

  def user_or_actors_are_admin?(obj)
    obj.admin_users.include?(@user) || (obj.admin_groups & @user.actors).present?
  end
end
