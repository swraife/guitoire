# TODO: Refactor :performer to be :viewer, so it can share more code with
# feat_query_service, and be extended for group viewers
module Query
  class ActivityService
    include VisibilityQueryHelpers
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
          .or(feat_create_activities)
          .or(routine_create_activities)
          .or(feat_role_follower_activities)
      )
    end

    def joins
      activities.join(feats, Arel::Nodes::OuterJoin).on(join_condition(feats, 'recipient'))
        .join(performers, Arel::Nodes::OuterJoin).on(join_condition(performers, 'owner'))
        .join(routines, Arel::Nodes::OuterJoin).on(join_condition(routines, 'trackable'))
    end

    def join_condition(joined_table, column)
      activities["#{column}_id".to_sym].eq(joined_table[:id])
        .and(activities["#{column}_type".to_sym].eq(str_class_of(joined_table)))
    end

    def play_activities
      activities[:key].eq('play.create')
        .and(recipient_feat_is_visible)
        .and(owner_is_visible)
    end

    def resource_activities
      activities[:key].eq('resource.create')
        .and(recipient_feat_is_visible)
        .and(owner_is_visible)
    end

    def feat_role_follower_activities
      activities[:key].eq('feat_role.create_follower')
        .and(recipient_feat_is_visible)
        .and(owner_is_visible)
    end

    def routine_create_activities
      activities[:key].eq('routine.create')
        .and(visibility_everyone?(routines)
          .or(visibility_friends?(routines)
            .and(owner_is_friend?(routines)))
          .or(is_admin?(routines)))
    end

    def feat_create_activities
      activities[:key].eq('feat.create')
        .and(recipient_feat_is_visible)
    end

    def recipient_feat_is_visible
      visibility_everyone?(feats)
        .or(visibility_friends?(feats).and(owner_is_friend?(feats)))
        .or(is_admin?(feats))
    end

    def owner_is_visible
      visibility_everyone?(performers)
        .or(visibility_friends?(performers).and(owner_is_friend?(activities)))
    end

    def polymorphic_join(arel_query, joined_table, column)
      arel_query.join(joined_table)
        .on(join_condition(joined_table, column))
    end

    def recipient_is_feat?
      activities[:recipient_type].eq('Feat')
    end

    def recipient_is_nil?
      activities[:recipient_type].eq(nil)
    end

    def str_class_of(table)
      table.send(:type_caster).send(:types).name
    end

    def feats
      @feats ||= Feat.arel_table
    end

    def trackable_feats
      @trackable_feats ||= Arel::Table.new(:feats, as: 'trackable_feats')
    end

    def performers
      @performers ||= Performer.arel_table
    end

    def routines
      @routines ||= Routine.arel_table
    end

    def friends_ids
      @friends_ids ||= performer.friendships_performer_ids.push(performer.id)
    end

    def admin_feats_ids
      @admin_feats_ids ||= performer.admin_feat_ids
    end

    def admin_routines_ids
      @admin_routines_ids ||= performer.admin_routine_ids
    end

    def admin_trackable_feats_ids
      admin_feats_ids
    end
  end
end