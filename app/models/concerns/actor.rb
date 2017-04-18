module Actor
  extend ActiveSupport::Concern

  def global_id
    to_global_id.to_param
  end

  def feat_tags(context = nil)
    tag_list_query(context, feats)
  end

  def feat_role_tags(context = nil)
    tag_list_query(context, feat_roles)
  end

  private

  def tag_list_query(context, association)
    context_query = context.nil? ? '' : { taggings: { context: context } }
    ActsAsTaggableOn::Tag.includes(:taggings)
                         .where(taggings: { taggable: association })
                         .where(context_query)
  end
end  
