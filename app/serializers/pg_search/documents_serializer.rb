class PgSearch::DocumentsSerializer < ActiveModel::Serializer
  has_many :documents
end
