desc 'recalculate feat and feat_role counter caches for plays_count and last_played_at'

task recalculate_plays_counter_caches: :environment do
  ActiveRecord::Base.transaction do
    feat_play_counts = Play.group(:feat_id).count
    feat_last_played_values =
      ActiveRecord::Base.connection.execute(
        "SELECT feat_id, max(created_at) FROM plays GROUP BY feat_id"
      ).values.to_h

    feat_play_counts.each do |k,v|
      Feat.find(k).update!(plays_count: v, last_played_at: feat_last_played_values[k])
      print '.'
    end
    puts 'feat counter cache update complete!'

    feat_role_play_counts = Play.group(:feat_role_id).count
    feat_role_last_played_values =
      ActiveRecord::Base.connection.execute(
        "SELECT feat_role_id, max(created_at) FROM plays GROUP BY feat_role_id"
      ).values.to_h

    feat_role_play_counts.each do |k,v|
      FeatRole.find(k).update!(plays_count: v, last_played_at: feat_role_last_played_values[k])
      print '.'
    end
    puts 'feat_role counter cache update complete!'
  end
end
