desc 'create performers for every user. Update user references to performer'

task create_performers: :environment do
  ActiveRecord::Base.transaction do
    User.all.each do |user|
      performer = Performer.create!(user: user)

      GroupRole.where(performer_id: user.id).update_all(performer_id: performer.id)
      Play.where(performer_id: user.id).update_all(performer_id: performer.id)
      Resource.where(creator: user)
              .update_all(creator_id: performer.id, creator_type: 'Performer')

      [Feat, Group].each do |klass|
        klass.where(creator_id: user.id).update_all(creator_id: performer.id)
      end

      [Feat, FeatRole, Routine, RoutineRole, PublicActivity::Activity].each do |klass|
        klass.where(owner: user)
             .update_all(owner_id: performer.id, owner_type: 'Performer')
      end
      print '.'
    end
    puts 'complete!'
  end
end