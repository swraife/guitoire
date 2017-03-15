module SongRoleOwner
  extend ActiveSupport::Concern

  included do
    has_many :song_roles, as: :owner, dependent: :destroy
    has_many :admin_song_roles, -> { admin }, as: :owner, class_name: 'SongRole'
    has_many :follower_song_roles, -> { follower }, as: :owner, class_name: 'SongRole'
    has_many :viewer_song_roles, -> { viewer }, as: :owner, class_name: 'SongRole'
    has_many :subscriber_song_roles, -> { subscriber }, as: :owner, class_name: 'SongRole'

    has_many :songs, through: :song_roles
    has_many :admin_songs, through: :admin_song_roles, source: :song
    has_many :viewer_songs, through: :viewer_song_roles, source: :song
    has_many :follower_songs, through: :follower_song_roles, source: :song
    has_many :subscriber_songs, through: :subscriber_song_roles, source: :song

    has_many :songs_as_owner, class_name: 'Song', as: :owner
  end
end
