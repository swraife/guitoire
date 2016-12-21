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

  validates_attachment_content_type :main, content_type: [/\Aimage\/.*\Z/, /\Aaudio\/.*\Z/, /\Atext\/.*\Z/, 'application/pdf',
    /application\/.*word\Z/, /application\/.*excel\Z/, /application\/vnd.*\Z/],
    message: 'Bad File Type'
  validates_attachment_size :main, {in: 0..50.megabytes, message: 'File is too big!'}
  validates_attachment_presence :main,
    message: 'File Missing'

  # true if should open in new browser tab; false if should download
  def displayable_in_browser?
    extension = File.extname(self.main_file_name)
    ['.pdf', '.jpg', '.png', '.gif', '.txt'].include? extension
  end
end
