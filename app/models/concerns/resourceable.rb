module Resourceable
  extend ActiveSupport::Concern

  included do
    has_many :resources, as: :target, dependent: :destroy
    has_many :file_resources, through: :resources, source: :resourceable, source_type: 'FileResource'
    has_many :url_resources, through: :resources, source: :resourceable, source_type: 'UrlResource'
  end
end