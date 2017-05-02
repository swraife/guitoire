# == Schema Information
#
# Table name: plays
#
#  id           :integer          not null, primary key
#  performer_id :integer
#  feat_role_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  feat_id      :integer
#

class Play < ApplicationRecord
  include PublicActivity::Model
  include TrackableAssociations

  tracked only: [:create], owner: :performer, recipient: :feat

  belongs_to :performer
  belongs_to :feat_role, counter_cache: true
  belongs_to :feat, counter_cache: true

  # To be deleted once owner is made polymorphic
  def owner
    performer
  end

  def create_flash_notice
    feat_name = performer.feat_name
    other_players_count = feat.players.count - 1
    others_text =
      if other_players_count.positive?
        "#{other_players_count} others have performed this #{feat_name} #{feat.plays.count - feat_role.plays.count} times."
      else
        ''
      end

    "#{feat_name.capitalize} performed! You have performed this #{feat_name} #{feat_role.plays.count} times! #{others_text}"
  end

  def feat_id
    feat.id
  end
end
