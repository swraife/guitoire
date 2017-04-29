module Query
  class FeatQueryService
    include VisibilityQueryHelpers

    attr_reader :actor, :viewer, :order

    def initialize(actor:, viewer:, order: 'order_by_name', filters: {})
      @actor = actor
      @viewer = viewer
      @filters = filters
      @order = set_order(order)
    end

    def find_feats
      Feat.includes(:feat_roles).where(query).order(order)
    end

    private

    def feat_roles
      @feat_roles ||= FeatRole.arel_table
    end

    def feats
      @feats ||= Feat.arel_table
    end

    def plays
      @plays ||= Play.arel_table
    end

    def query
      feats[:id].in(feat_matches.project(feats[:id]))
    end

    def feat_matches
      joins.where(
        feat_role_owner_is_actor
        .and(
          visibility_everyone?(feats)
          .or(visibility_friends?(feats).and(owner_is_friend?(feats)))
          .or(is_admin?(feats))
        )
      )
    end

    def joins
      feats.join(feat_roles).on(feats[:id].eq(feat_roles[:feat_id]))
    end

    def feat_role_owner_is_actor
      if actor
        feat_roles[:owner_type].eq(actor.class)
                               .and(feat_roles[:owner_id].eq(actor.id))
      else
        feat_roles[:id].not_eq(nil)
      end
    end

    def feat_role_subscriber?
      feat_roles[:role].in([1,2])
    end

    def set_order(order_param)
      case order_param
      when 'order_by_name'
        feats[:name]
      when 'order_by_last_played'
        'plays.created_at desc nulls last'
      when 'order_by_plays_count'
        'feat_roles.plays_count desc'
      when 'order_by_created_at'
        feats[:created_at].desc
      end
    end

    def friends_ids
      @friends_ids ||= viewer.friendships_performer_ids.push(viewer.id)
    end

    def admin_feats_ids
      @admin_feats_ids ||= FeatRole.admin.where(owner: viewer.actors).pluck(:feat_id)
    end
  end
end
