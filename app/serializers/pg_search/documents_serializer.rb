class PgSearch::DocumentsSerializer < ActiveModel::Serializer
  has_many :documents, serializer: DocumentSerializer
end
