module Query
  class FeatQueryService
    include VisibilityQueryHelpers

    attr_reader :actor, :viewer, :order, :tags, :name

    def initialize(actor:, viewer:, order: 'order_by_name', filters: {})
      @actor = actor
      @viewer = viewer
      @filters = set_filters(filters)
      @order = set_order(order)
    end

    def find_feats
      @feats_list ||= Feat.includes(:tags, feat_roles: :plays)
                          .send(*tag_query)
                          .where(query).send(order, actor&.id)
    end

    def last_played_dates
      @last_played_dates ||= Play.joins(:feat_role)
                                 .where(feat_roles: {feat_id: find_feats.ids})
                                 .order(created_at: :desc)
                                 .pluck(:feat_id, :created_at)
                                 .uniq(&:first).to_h
    end

    private

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
        ).and(name_query)
      )
    end

    def order_matches
      joins.where(feat_role_owner_is_actor)
    end

    def joins
      feats.join(feat_roles).on(feats[:id].eq(feat_roles[:feat_id]))
    end

    def feat_role_owner_is_actor
      if actor
        feat_roles[:owner_type].eq(actor.class)
                               .and(feat_roles[:owner_id].eq(actor.id))
                               .and(feat_roles[:role].not_eq(0))
      else
        where_all
      end
    end

    def tag_query
      tags ? [:tagged_with, tags] : :all
    end

    def name_query
      name ? feats[:name].matches("%#{name}%") : where_all
    end

    # def filter_tags
    #   tags ? taggings[:tag_id].in(tag_ids) : where_all
    # end

    def where_all
      feats[:id].not_eq(nil)
    end

    def feat_role_subscriber?
      feat_roles[:role].in([1, 2])
    end

    def set_order(order_param)
      case order_param
      when 'order_by_name'
        :order_by_name
      when 'order_by_last_played'
        :order_by_last_played
      when 'order_by_plays_count'
        :order_by_plays_count
      when 'order_by_created_at'
        :order_by_created_at
      end
    end

    def friends_ids
      @friends_ids ||= viewer.friendships_performer_ids.push(viewer.id)
    end

    def admin_feats_ids
      @admin_feats_ids ||= FeatRole.admin.where(owner: viewer.actors).pluck(:feat_id)
    end

    def set_filters(filters)
      @tags = filters[:tags]
      @name = filters[:name]
    end

    def feat_roles
      @feat_roles ||= FeatRole.arel_table
    end

    def feats
      @feats ||= Feat.arel_table
    end

    def plays
      @plays ||= Play.arel_table
    end
  end
end
