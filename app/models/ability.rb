# TODO: Add friends!
class Ability
  include CanCan::Ability

  attr_reader :actors

  def initialize(user, params)
    @user = user || User.new # guest user (not logged in)
    # TESTING: This works so far, but hasn't been fully thought out/tested.
    @target_user = params[:user_id] ? User.find(params[:user_id]) : @user

    if @user.admin?
      can :manage, :all
    else
      if @target_user.visible_to? @user
        can :show, [Song, Routine] do |song|
          song.everyone? || user_or_actors_are_admin?(song)
        end

        can :index, [Song, Routine, Group]
      end

      can [:create, :update, :destroy], [Song, Routine] do |obj|
        user_is_in_owner_users?(obj.owner) || user_or_actors_are_admin?(obj)
      end

      can :copy, Song do |song|
        song.copiable?
      end

      can :follow, Song do |song|
        !song.hidden?
      end

      can [:create, :update, :destroy], RoutineRole do |obj|
        user_is_in_owner_users?(obj.owner)
      end

      can [:create, :update, :destroy], SongRole do |song_role|
        user_is_in_owner_users?(song_role.owner) &&
          song_role.song.permissible_roles.include?(params[:song_role][:role])
      end

      can :create, Play do |play|
        play.song.everyone? || user_or_actors_are_admin?(play.song)
      end

      can [:create, :update, :destroy], SetListSong do |set_list_song|
        user_or_actors_are_admin? set_list_song.routine
      end

      can [:update, :destroy], Group do |group|
        group.admin_users.include? @user
      end

      can :create, Group

      can :show, Group do |group|
        group.everyone? || group.admin_users.include?(@user)
      end

      can :destroy, Resource do |resource|
        user_or_actors_are_admin? resource.target
      end
    end
  end

  private

  # This makes :create abilities pass where obj_roles haven't beeen created yet
  def user_is_in_owner_users?(owner)
    owner.users.include? @user
  end

  def user_or_actors_are_admin?(obj)
    obj.admin_users.include?(@user) || (obj.admin_groups & @user.actors).present?
  end
end
