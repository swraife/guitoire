module Query
  class FeatQueryService
    include VisibilityQueryHelpers

    attr_reader :actor, :viewer, :order

    def initialize(actor:, viewer:, order: 'name', filters: {})
      @actor = actor
      @viewer = viewer
      @filters = filters
      @order = order
    end

    def find_feats
      Feat.includes(:feat_roles, :plays).where(query).group(feats[:id]).order(order_by)
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

    def order_by
      if order == 'last_played'
        'max(plays.created_at) DESC NULLS LAST'
      elsif order == 'created_at'
        feats[:created_at].desc
      elsif order == 'plays_count'
        'max(feat_roles.plays_count) DESC NULLS LAST'
      else
        feats[:name]
      end
    end

    def feat_matches
      join_feat_roles.where(
        feat_role_owner_is_actor
        .and(visibility_everyone?(feats))
        .or(visibility_friends?(feats).and(owner_is_friend?(feats)))
        .or(is_admin?(feats))
      )
    end

    def join_feat_roles
      feats.join(feat_roles).on(
        feats[:id].eq(feat_roles[:feat_id]).and(feat_roles[:role].in([1,2]))
      ).join(plays, Arel::Nodes::OuterJoin).on(
        feat_roles[:id].eq(plays[:feat_role_id])
      )
    end

    def feat_role_owner_is_actor
      feat_roles[:owner_type].eq(actor.class)
                             .and(feat_roles[:owner_id].eq(actor[:id]))
    end

    def friends_ids
      @friends_ids ||= viewer.friendships_performer_ids.push(viewer.id)
    end

    def admin_feats_ids
      @admin_feats_ids ||= viewer.admin_feat_ids
    end
  end
end
