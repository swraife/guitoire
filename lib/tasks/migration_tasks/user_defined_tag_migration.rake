desc 'data migration for converting song fields to customizable feat fields'

task user_defined_tag_migration: :environment do
  Feat.all.each do |feat|
    feat.set_tag_list_on(:music_keys, feat.music_key)
    feat.set_tag_list_on(:tempos, feat.tempo)
    feat.set_tag_list_on(:scales, feat.scale)
    feat.set_tag_list_on(:time_signatures, feat.time_signature)
    feat.save!
  end
end
