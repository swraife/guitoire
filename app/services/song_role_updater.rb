class SongRoleUpdater
  attr_reader :song, :admin_user_ids, :admin_group_ids

  def initialize(song, admin_user_ids, admin_group_ids)
    @song = song
    @admin_user_ids = format_ids(admin_user_ids)
    @admin_group_ids = format_ids(admin_group_ids)
    add_song_owner
  end

  def update!
    SongRole.admin.where(song: song).each do |song_role|
      next if (admin_user_ids.include?(song_role.owner_id) && song_role.owner_type == 'User')
      next if (admin_group_ids.include?(song_role.owner_id) && song_role.owner_type == 'Group')
      song_role.destroy!
    end

    {'User' => admin_user_ids, 'Group' => admin_group_ids}.each do |k, v|
      v.each do |owner_id|
        SongRole.where(song: song, owner_id: owner_id, owner_type: k)
          .first_or_initialize.admin!
      end
    end
  end

  private

  def add_song_owner
    admin_user_ids.push(song.owner_id) if song.owner_type == 'User'
    admin_group_ids.push(song.owner_id) if song.owner_type == 'Group'
  end

  def format_ids(ids)
    ids.reject(&:blank?).map(&:to_i)
  end
end
