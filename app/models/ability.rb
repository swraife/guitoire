# TODO: Add friends!
class Ability
  include CanCan::Ability

  attr_reader :actors

  def initialize(performer, params)
    @performer = performer || Performer.new # guest performer (not logged in)
    @user = performer.user
    # TESTING: This works so far, but hasn't been fully thought out/tested.
    @target_performer = params[:performer_id] ? Performer.find(params[:performer_id]) : @performer

    if @user.admin?
      can :manage, :all
    else
      if @target_performer.visible_to? @performer
        can :show, [Song, Routine] do |song|
          song.everyone? || performer_or_actors_are_admin?(song)
        end

        can :index, [Song, Routine, Group]
      end

      can [:create, :update, :destroy], [Song, Routine] do |obj|
        performer_is_in_owner_performers?(obj.owner) || performer_or_actors_are_admin?(obj)
      end

      can :copy, Song do |song|
        song.copiable?
      end

      can :follow, Song do |song|
        !song.hidden?
      end

      can [:create, :update, :destroy], RoutineRole do |obj|
        performer_is_in_owner_performers?(obj.owner)
      end

      can [:create, :update, :destroy], SongRole do |song_role|
        performer_is_in_owner_performers?(song_role.owner) &&
          song_role.song.permissible_roles.include?(params[:song_role][:role])
      end

      can :create, Play do |play|
        play.song.everyone? || performer_or_actors_are_admin?(play.song)
      end

      can [:create, :update, :destroy], SetListSong do |set_list_song|
        performer_or_actors_are_admin? set_list_song.routine
      end

      can [:update, :destroy], Group do |group|
        group.admin_performers.include? @performer
      end

      can :create, Group

      can :show, Group do |group|
        group.everyone? || group.admin_performers.include?(@performer)
      end

      can :destroy, Resource do |resource|
        performer_or_actors_are_admin? resource.target
      end

      can :index, Performer

      can :show, Performer do |target_performer|
        target_performer.everyone? || target_performer.user == @performer.user ||
          target_performer.friendships_performer_ids(:accepted).include?(@performer.id)
      end

      can :update, Performer do |performer|
        performer.user == @user
      end

      can :update, User do |user|
        user == @user
      end

      can :index, :user_performer if params[:user_id].to_i == @user.id
    end
  end

  private

  # This makes :create abilities pass where obj_roles haven't beeen created yet
  def performer_is_in_owner_performers?(owner)
    owner.performers.include? @performer
  end

  def performer_or_actors_are_admin?(obj)
    obj.admin_performers.include?(@performer) || (obj.admin_groups & @performer.actors).present?
  end
end
