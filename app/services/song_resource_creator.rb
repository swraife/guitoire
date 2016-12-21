class SongResourceCreator
  attr_reader :song_id, :resource, :resourceable, :song_resource

  def initialize(song_id:, resource: Resource.new, resourceable:)
    @song_id = song_id
    @resource = resource
    @resourceable = resourceable
  end

  def create
    ActiveRecord::Base.transaction do
      resourceable.save!
      resource.resourceable = resourceable
      resource.save!
      @song_resource = SongResource.create!(song_id: song_id, resource: resource)
    end
    {resource: resource, song_resource: song_resource, resourceable: resourceable}
  rescue ActiveRecord::ActiveRecordError => exception
    # TODO: do something with the exception
    return false
  end
end