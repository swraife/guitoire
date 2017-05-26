class PgSearch::DocumentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :url, :name, :avatar, :description, :searchable_type, :username

  def url
    polymorphic_path(object.searchable)
  end

  def name
    object.searchable.public_name
  end

  def username
    if object.searchable.is_a?(Performer)
      object.searchable.username
    else
      ''
    end
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
      object.searchable.base_tags.first(10)
            .map { |tag| I18n.t("skill_names.#{tag.name}", default: tag.name) }
            .join(', ')
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