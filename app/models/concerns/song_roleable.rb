module SongRoleable
  extend ActiveSupport::Concern

  included do
    has_many :song_roles, dependent: :destroy
    has_many :admin_song_roles, -> { admin }, class_name: 'SongRole'
    has_many :follower_song_roles, -> { follower }, class_name: 'SongRole'
    has_many :viewer_song_roles, -> { viewer }, class_name: 'SongRole'
    has_many :subscriber_song_roles, -> { subscriber }, class_name: 'SongRole'
  end
end