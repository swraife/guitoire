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

  def displayable_in_browser?
    true
  end

  def main_link
    url
  end

  def main_link_name
    url
  end

  def icon
    'fa-link'
  end

  private

  def format_url
    self.url = "http://#{url}" unless url[/^https?/]
  end
end
