class SongResourceCreator
  attr_reader :song_id, :resource, :resourceable, :song_resource, :errors

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
  rescue ActiveRecord::ActiveRecordError => exception
    @errors = exception
  end
end