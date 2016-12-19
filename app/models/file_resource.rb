# == Schema Information
#
# Table name: file_resources
#
#  id                :integer          not null, primary key
#  main_file_name    :string
#  main_content_type :string
#  main_file_size    :integer
#  main_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class FileResource < ApplicationRecord
  has_many :resources, as: :resourceable

  has_attached_file :main
end
