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
      PublicActivity::Activity.includes(:trackable, :owner, recipient: [:creator, :base_tags])
    end

    def activities
      @arel_table ||= PublicActivity::Activity.arel_table
    end

    def query
      activities[:id].in(activity_matches.project(activities[:id]))
    end

    def activity_matches
      joins.where(
        visible_activities.and(
          belongs_to_friend.or(performer_belongs_to_area).or(tagged_with_skills))
      )
    end

    def joins
      activities.join(feats, Arel::Nodes::OuterJoin).on(join_condition(feats, 'recipient'))
        .join(performers, Arel::Nodes::OuterJoin).on(join_condition(performers, 'owner'))
        .join(routines, Arel::Nodes::OuterJoin).on(join_condition(routines, 'trackable'))
        .join(taggings, Arel::Nodes::OuterJoin).on(tagging_join_condition)
    end

    def join_condition(joined_table, column)
      activities["#{column}_id".to_sym].eq(joined_table[:id])
        .and(activities["#{column}_type".to_sym].eq(str_class_of(joined_table)))
    end

    def tagging_join_condition
      feats[:id].eq(taggings[:taggable_id])
                .and(taggings[:taggable_type].eq('Feat'))
                .and(taggings[:tag_id].in(tag_ids))
    end

    def visible_activities
      play_activities
        .or(resource_activities)
        .or(feat_create_activities)
        .or(routine_create_activities)
        .or(feat_role_follower_activities)
        .or(friendship_activities)
    end

    def belongs_to_friend
      activities[:owner_type].eq('Performer')
        .and(activities[:owner_id].in(friends_ids))
    end

    def performer_belongs_to_area
      activities[:owner_type].eq('Performer')
        .and(activities[:owner_id].in(area_performer_ids))
    end

    def tagged_with_skills
      activities[:recipient_id].eq(taggings[:taggable_id])
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

    def friendship_activities
      activities[:key].eq('friendship.accepted')
        .and(visibility_everyone?(performers))
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

    def taggings
      @taggings ||= ActsAsTaggableOn::Tagging.arel_table
    end

    def friends_ids
      @friends_ids ||= performer.friendships_performer_ids.push(performer.id)
    end

    def tag_ids
      @tag_ids ||= performer.base_tag_ids
    end

    def area_performer_ids
      @area_performer_ids ||= performer.area.performer_ids
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
