desc 'copy song_resources to resources'

task delete_song_resources: :environment do
  ActiveRecord::Base.transaction do
    Resource.includes(song_resources: :song).all.each do |resource|
      if resource.song_resources.count == 1
        print '.'
        resource.update!(owner: resource.song_resources.first.song)
      else 
        raise "what? how many song resources do you have resource: #{resource.id}?" 
      end
    end
    puts 'complete!'
  end
end