class SongRoleUpdater
  attr_reader :song, :admin_user_ids

  def initialize(song, admin_user_ids)
    @song = song
    @admin_user_ids = admin_user_ids.each(&:to_i).push(song.creator_id)
  end

  def update!
    SongRole.admin.where(song: song).each do |song_role|
      next if admin_user_ids.include? song_role.user_id
      song_role.destroy
    end
    admin_user_ids.each do |user_id|
      SongRole.where(song: song, user_id: user_id).first_or_initialize.admin!
    end
  end
end
