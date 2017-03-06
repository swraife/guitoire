desc 'update play.song_id to song_role_id'

task update_plays_to_song_role_id: :environment do
  ActiveRecord::Base.transaction do
    Play.all.each do |play|
      song_role = SongRole.where(user: play.user, song_id: play.song_role_id).first_or_create
      play.update!(song_role: song_role)
      print '.'
    end
    puts 'complete!'
  end
end