desc 'update songs to have polymorphic owner'

task update_songs_owner: :environment do
  ActiveRecord::Base.transaction do
    Song.all.each do |song|
      song.update!(owner: song.creator)
      print '.'
    end
    puts 'complete!'
  end
end