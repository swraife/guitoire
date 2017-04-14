class PgSearch::DocumentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :url, :name, :avatar, :description, :searchable_type

  def url
    polymorphic_path(object.searchable)
  end

  def name
    object.searchable.public_name
  end

  def avatar
    if object.searchable.is_a? Feat
      object.searchable.owner.avatar.url(:thumb)
    else
      object.searchable.avatar.url(:thumb)
    end
  end

  def description
    if object.searchable.is_a? Performer
      ''
    elsif object.searchable.is_a? Group
      object.searchable.performers.map(&:public_name)
    elsif object.searchable.is_a? Feat
      object.searchable.owner.public_name
    end
  end

  def type
    object.searchable_type
  end
end