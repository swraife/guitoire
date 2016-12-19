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
end
