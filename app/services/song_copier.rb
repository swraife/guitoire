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
    self.song_copy = Song.create!(attributes.merge(creator: copy_creator,
                                              version_list: song.version_list,
                                              generic_list: song.generic_list,
                                              composer_list: song.composer_list))
    song.song_resources.each do |song_resource|
      SongResource.create!(song_id: song_copy.id, resource_id: song_resource.id)
    end
    song_copy
  end
end