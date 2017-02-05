class JimSongCreator
  def self.create_songs
    entries = Dir.entries('public/jim_songs')
      .delete_if { |item| ['.','..'].include?(item) }

    jim_song_path = Rails.root.join('public/jim_songs/')

    ActiveRecord::Base.transaction do
      entries.each do |file_name|
        puts "creating #{file_name}"
        song = Song.where(user_id: 2, name: file_name.split('.')[0])
                   .first_or_initialize
        song.persisted? ? next : song.save!

        path = jim_song_path + file_name
        file_resource = FileResource.new(main: File.new(path, 'r'))

        Resource.create!(
          target: song, resourceable: file_resource
        )
      end
    end

  rescue ActiveRecord::ActiveRecordError => exception
    @errors = exception
    puts @errors    
  end
end