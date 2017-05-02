module Query
  class FeatRoleQueryService
    include VisibilityQueryHelpers

    attr_reader :actor, :viewer, :order, :tag_ids

    def initialize(actor:, viewer:, order: 'order_by_name', filters: {})
      @actor = actor
      @viewer = viewer
      @filters = set_filters(filters)
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
        .and(filter_tags)
      )
    end

    def joins
      feat_roles.join(feats)
                .on(feats[:id].eq(feat_roles[:feat_id]))
                .join(taggings, Arel::Nodes::OuterJoin)
                .on(taggings[:taggable_id].eq(feats[:id]).and(taggings[:taggable_type].eq('Feat')))
    end

    def feat_role_owner_is_actor
      if actor
        feat_roles[:owner_type].eq(actor.class)
                               .and(feat_roles[:owner_id].eq(actor.id))
      else
        where_all
      end
    end

    def filter_tags
      tag_ids ? taggings[:tag_id].in(tag_ids) : where_all
    end

    def where_all
      feat_roles[:id].not_eq(nil)
    end

    def friends_ids
      @friends_ids ||= viewer.friendships_performer_ids.push(viewer.id)
    end

    def admin_feats_ids
      @admin_feats_ids ||= FeatRole.admin.where(owner: viewer.actors).pluck(:feat_id)
    end

    def taggings
      @taggings ||= ActsAsTaggableOn::Tagging.arel_table
    end

    def set_filters(filters)
      @tag_ids = filters[:tag_ids]
    end
  end
end
