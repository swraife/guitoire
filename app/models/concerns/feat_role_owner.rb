module FeatRoleOwner
  extend ActiveSupport::Concern

  included do
    has_many :feat_roles, as: :owner, dependent: :destroy
    has_many :admin_feat_roles, -> { admin }, as: :owner, class_name: 'FeatRole'
    has_many :follower_feat_roles, -> { follower }, as: :owner, class_name: 'FeatRole'
    has_many :viewer_feat_roles, -> { viewer }, as: :owner, class_name: 'FeatRole'
    has_many :subscriber_feat_roles, -> { subscriber }, as: :owner, class_name: 'FeatRole'

    has_many :feats, through: :feat_roles
    has_many :admin_feats, through: :admin_feat_roles, source: :feat
    has_many :viewer_feats, through: :viewer_feat_roles, source: :feat
    has_many :follower_feats, through: :follower_feat_roles, source: :feat
    has_many :subscriber_feats, through: :subscriber_feat_roles, source: :feat

    has_many :feats_as_owner, class_name: 'Feat', as: :owner
  end
end
