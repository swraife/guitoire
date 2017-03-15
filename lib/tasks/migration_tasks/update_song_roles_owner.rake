desc 'update song_roles to have polymorphic owner'

task update_song_roles_owner: :environment do
  if SongRole.update_all(owner_type: 'User')
    puts 'complete!'
  end
end