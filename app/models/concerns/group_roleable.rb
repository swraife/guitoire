module GroupRoleable
  extend ActiveSupport::Concern

  included do
    has_many :group_roles, dependent: :destroy
    has_many :admin_group_roles, -> { admin }, class_name: 'GroupRole'
  end
end