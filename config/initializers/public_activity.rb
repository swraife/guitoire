PublicActivity::Activity.class_eval do
  def group
    group = [owner, created_at.yday, key]
    group.push(recipient.creator) if key == 'song_role.create_follower'
    group.push(recipient) if key == 'resource.create'

    group
  end
end