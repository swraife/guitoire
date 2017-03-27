PublicActivity::Activity.class_eval do
  def group
    group = [owner, created_at.yday, key]
    group.push(recipient.creator) if key == 'song_role.create_follower'
    group.push(recipient) if key == 'resource.create'

    group
  end

  def self.activities_with_associations_preloaded
    activities = includes(:trackable, :owner, :recipient)

    activities_by_recipient_type = activities.group_by(&:recipient_type)

    {'Performer' => [:user], 'Song' => [:creator]}.each do |type, associations|
      type_activities = activities_by_recipient_type.fetch(type,[])
      preload_record_array(type_activities, recipient: associations)
    end

    activities
  end

  def self.preload_record_array(record_array, preload_hash)  
    ActiveRecord::Associations::Preloader.new
      .preload(record_array, preload_hash)
  end  
end