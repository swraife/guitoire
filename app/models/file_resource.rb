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

  has_attached_file :main,
                    styles: lambda { |a|
                      if ['image/jpeg', 'image/png', 'image/gif'].include?(a.content_type)
                        { medium: '300x400>', large: '476x635>', thumb: '100x100#' }
                      else
                        {}
                      end
                    }

  validates_attachment_content_type :main, content_type: [
    /\Aimage\/.*\Z/, /\Aaudio\/.*\Z/, /\Atext\/.*\Z/, 'application/pdf',
    /application\/.*word\Z/, /application\/.*excel\Z/, /application\/vnd.*\Z/,
    /\Avideo\/.*\Z/], message: 'Bad File Type'
  validates_attachment_size :main, in: 0..100.megabytes, message: 'File is too big!'
  validates_attachment_presence :main,
    message: 'File Missing'

  def displayable_in_browser?
    extension = main_content_type.split('/')[-1]
    %w(pdf jpg png gif txt jpeg).include? extension
  end

  def url
    main.url(:original)
  end

  def url_name
    main_file_name
  end

  def icon
    case main_content_type
    when 'application/pdf'
      'fa-file-pdf-o'
    when 'image/jpeg', 'image/gif', 'image/png'
      'fa-file-image-o'
    when 'audio/wav', 'audio/mp3', 'audio/x-wav', 'audio/mpeg'
      'fa-file-audio-o'
    when 'video/mp4', 'video/quicktime'
      'fa-file-video-o'
    else
      'fa-file-o'
    end
  end

  def display_type_name
    case main_content_type
    when 'application/pdf'
      'pdf'
    when 'image/jpeg', 'image/gif', 'image/png'
      'image'
    when 'audio/wav', 'audio/mp3', 'audio/x-wav', 'audio/mpeg'
      'audio file'
    when 'video/mp4', 'video/quicktime'
      'video'
    else
      'file'
    end
  end
end
