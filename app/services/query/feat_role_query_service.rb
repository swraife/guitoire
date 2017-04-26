module Query
  class FeatRoleQueryService
    include VisibilityQueryHelpers

    attr_reader :actor, :viewer, :order

    def initialize(actor:, viewer:, order: 'order_by_name', filters: {})
      @actor = actor
      @viewer = viewer
      @filters = filters
      @order = order
    end

    def find_feat_roles
      FeatRole.includes(feat: :tags).where(query).send(order)
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
      feat_roles[:id].in(feat_role_matches.project(feat_roles[:id]))
    end

    def feat_role_matches
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
      feat_roles.join(feats).on(feats[:id].eq(feat_roles[:feat_id]))
    end

    def feat_role_owner_is_actor
      if actor
        feat_roles[:owner_type].eq(actor.class)
                               .and(feat_roles[:owner_id].eq(actor.id))
      else
        feat_roles[:id].not_eq(nil)
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
