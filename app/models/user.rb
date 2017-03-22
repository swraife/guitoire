# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string           default("")
#  last_name              :string           default("")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  role                   :integer          default("subscriber")
#  visibility             :integer          default("everyone")
#  default_performer_id   :integer
#

class User < ApplicationRecord
  include TrackableAssociations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :default_performer, class_name: 'Performer'

  has_many :performers

  has_many :messages
  has_many :message_copies
  has_many :user_message_threads
  has_many :message_threads, through: :user_message_threads

  enum role: [:subscriber, :admin]
  enum visibility: [:everyone, :friends]

  before_create { |user| user.first_name.capitalize! && user.last_name.capitalize! }

  acts_as_tagger

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: 'https://s3-us-west-2.amazonaws.com/guitoire/assorted/default_avatar.png'
  validates_attachment_content_type :avatar,
                                    :content_type => ['image/jpg', 'image/jpeg', 'image/png']

  def public_name
    name = "#{first_name} #{last_name}"
    name.present? ? name : "User#{id}"
  end
end
