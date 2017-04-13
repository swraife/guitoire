class ActivityService
  attr_reader :performer

  def initialize(performer)
    @performer = performer
  end

  def dashboard_activities
    public_activity.where(query)
  end

  private

  def public_activity
    PublicActivity::Activity.includes(:trackable, :owner, recipient: [:creator, :tags])
  end

  def activities
    @arel_table ||= PublicActivity::Activity.arel_table
  end

  def query
    activities[:id].in(activity_matches.project(activities[:id]))
  end

  def activity_matches
    joins.where(
      play_activities
        .or(resource_activities)
        .or(song_create_activities)
        .or(routine_create_activities)
        .or(song_role_follower_activities)
    )
  end

  def joins
    activities.join(songs, Arel::Nodes::OuterJoin).on(join_condition(songs, 'recipient'))
      .join(performers, Arel::Nodes::OuterJoin).on(join_condition(performers, 'owner'))
      .join(routines, Arel::Nodes::OuterJoin).on(join_condition(routines, 'trackable'))
  end

  def play_activities
    activities[:key].eq('play.create')
      .and(recipient_song_is_visible)
      .and(owner_is_visible)
  end

  def resource_activities
    activities[:key].eq('resource.create')
      .and(recipient_song_is_visible)
      .and(owner_is_visible)
  end

  def song_role_follower_activities
    activities[:key].eq('song_role.create_follower')
      .and(recipient_song_is_visible)
      .and(owner_is_visible)
  end

  def routine_create_activities
    activities[:key].eq('routine.create')
      .and(visibility_everyone?(routines)
        .or(visibility_friends?(routines)
          .and(owner_is_friend?(routines)))
        .or(is_admin?(routines)))
  end

  def song_create_activities
    activities[:key].eq('song.create')
      .and(recipient_song_is_visible)
  end

  def recipient_song_is_visible
    visibility_everyone?(songs)
      .or(visibility_friends?(songs).and(owner_is_friend?(songs)))
      .or(is_admin?(songs))
  end

  def owner_is_visible
    visibility_everyone?(performers)
      .or(visibility_friends?(performers).and(owner_is_friend?(activities)))
  end

  def polymorphic_join(arel_query, joined_table, column)
    arel_query.join(joined_table)
      .on(join_condition(joined_table, column))
  end

  def join_condition(joined_table, column)
    activities["#{column}_id".to_sym].eq(joined_table[:id])
      .and(activities["#{column}_type".to_sym].eq(str_class_of(joined_table)))
  end

  def visibility_everyone?(table)
    table[:visibility].eq('everyone')
  end

  def visibility_friends?(table)
    table[:visibility].eq('friends')
  end

  def owner_is_friend?(table)
    table[:owner_id].in(friends_ids)
                    .and(table[:owner_type].eq('Performer'))
  end

  def is_admin?(table)
    table[:visibility].eq('only_admins')
                      .and(table[:id].in(send("admin_#{table.name}_ids")))
  end

  def recipient_is_song?
    activities[:recipient_type].eq('Song')
  end

  def recipient_is_nil?
    activities[:recipient_type].eq(nil)
  end

  def str_class_of(table)
    table.send(:type_caster).send(:types).name
  end

  def songs
    @songs ||= Song.arel_table
  end

  def trackable_songs
    @trackable_songs ||= Arel::Table.new(:songs, as: 'trackable_songs')
  end

  def performers
    @performers ||= Performer.arel_table
  end

  def routines
    @routines ||= Routine.arel_table
  end

  def friends_ids
    @friends_ids ||= performer.friendships_performer_ids
  end

  def admin_songs_ids
    @admin_songs_ids ||= performer.admin_song_ids
  end

  def admin_routines_ids
    @admin_routines_ids ||= performer.admin_routine_ids
  end

  def admin_trackable_songs_ids
    admin_songs_ids
  end
end
