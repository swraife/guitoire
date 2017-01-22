# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
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
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :created_songs, class_name: 'Song', foreign_key: :creator_id

  has_many :song_roles
  has_many :songs, through: :song_roles

  has_many :set_list_users
  has_many :set_lists, through: :set_list_users

  acts_as_tagger

  def admin_songs
    @admin_songs ||= songs.includes(:song_roles).where(song_roles: { role: SongRole.roles[:admin] })
  end

  def subscriber_songs
    @subscriber_songs ||= songs.includes(:song_roles).where(song_roles: { role: SongRole.roles[:subscriber] }) 
  end

  def song_tags(context=nil)
    context_query = context.nil? ? '' : { taggings: { context: context } }
    ActsAsTaggableOn::Tag.includes(:taggings).where(taggings: { taggable: songs}).where(context_query)
  end
end
