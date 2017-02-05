module TrackableAssociations
  extend ActiveSupport::Concern
  included do
    has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy
    has_many :activities_as_owner, as: :owner, class_name: 'PublicActivity::Activity', dependent: :destroy
    has_many :activities_as_recipient, as: :recipient, class_name: 'PublicActivity::Activity', dependent: :destroy
  end
end