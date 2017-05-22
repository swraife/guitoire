module Query
  class FeatQueryService
    include VisibilityQueryHelpers

    attr_reader :actors, :viewer, :order, :tags, :name

    def initialize(actors:, viewer:, order: 'order_by_name', filters: {})
      @actors = actors
      @viewer = viewer
      @filters = set_filters(filters)
      @order = set_order(order)
    end

    def find_feats
      @feats_list ||= Feat.joins(:feat_roles)
                          .send(*tag_query)
                          .where(query)
                          .send(order, actors)
                          .preload(:feat_roles, :base_tags)
    end

    private

    def query
      feats[:id].in(feat_matches.project(feats[:id]))
    end

    def feat_matches
      joins.where(
        feat_role_owner_is_in_actors
        .and(
          visibility_everyone?(feats)
          .or(is_admin?(feats))
        ).and(name_query)
      )
    end

    def joins
      feats.join(feat_roles).on(feats[:id].eq(feat_roles[:feat_id]))
    end

    def feat_role_owner_is_in_actors
      if actors.present?
        feat_roles[:role].not_eq(0)
                         .and((feat_roles[:owner_type].eq('Performer')
                           .and(feat_roles[:owner_id].in(performer_actors.map(&:id))))
                         .or(feat_roles[:owner_type].eq('Group')
                           .and(feat_roles[:owner_id].in(group_actors.map(&:id)))))
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

    def followed_ids
      @followed_ids ||= viewer.followed_ids.push(viewer.id)
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

    def performer_actors
      actors.select { |actor| actor.is_a? Performer }
    end

    def group_actors
      actors.select { |actor| actor.is_a? Group }
    end
  end
end
