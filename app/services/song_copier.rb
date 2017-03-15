class SongCopier
  attr_accessor :song, :song_copy, :copy_creator

  def initialize(song:, copy_creator:)
    @song = song
    @copy_creator = copy_creator
  end

  def copy!
    attributes = song.attributes.slice(
      'name', 'description', 'music_key', 'scale', 'time_signature', 'tempo'
    )
    self.song_copy = Song.create!(
      attributes.merge(creator: copy_creator,
                       owner: copy_creator,
                       version_list: song.version_list,
                       generic_list: song.generic_list,
                       composer_list: song.composer_list)
    )

    song.resources.each do |resource|
      Resource.create!(target: song_copy,
                       resourceable: resource.resourceable,
                       creator: copy_creator)
    end
    song_copy
  end
end
