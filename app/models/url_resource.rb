# == Schema Information
#
# Table name: url_resources
#
#  id         :integer          not null, primary key
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UrlResource < ApplicationRecord
  has_many :resources, as: :resourceable
  before_save :format_url

  def self.valid_url?(uri)
    uri = URI.parse(uri)
  rescue URI::InvalidURIError
    false
  end

  def displayable_in_browser?
    true
  end

  def url_name
    url
  end

  def icon
    'fa-link'
  end

  def display_type_name
    'link'
  end

  private

  def format_url
    self.url = "http://#{url}" unless url[/^https?/]
  end
end
