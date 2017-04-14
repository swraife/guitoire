desc 'rename songs to feats' 

task rename_songs_to_feats: :environment do
  PublicActivity::Activity.where(recipient_type: 'Song').update_all(recipient_type: 'Feat')
  PublicActivity::Activity.where(trackable_type: 'Song').update_all(trackable_type: 'Feat')
  PublicActivity::Activity.where(trackable_type: 'SongRole').update_all(trackable_type: 'FeatRole')
  PublicActivity::Activity.where(key: 'song.create').update_all(key: 'feat.create')
  PublicActivity::Activity.where(key: 'song_role.create_follower').update_all(key: 'feat_role.create_follower')

  Resource.where(target_type: 'Song').update_all(target_type: 'Feat')

  ActsAsTaggableOn::Tagging.where(taggable_type: 'Song').update_all(taggable_type: 'Feat')
end