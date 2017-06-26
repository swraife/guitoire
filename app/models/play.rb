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
  belongs_to :feat_role
  belongs_to :feat

  after_create :increment_feat_and_feat_roles_counter
  after_destroy :decrement_feat_and_feat_roles_counter
  # To be deleted once owner is made polymorphic
  def owner
    performer
  end

  def create_flash_notice
    feat_name = performer.feat_name
    other_players_count = feat.players.count - 1
    others_text =
      if other_players_count.positive?
        "#{other_players_count} others have performed this #{feat_name}" +
        " #{feat.plays.count - feat_role.plays.count} times."
      else
        ''
      end

    "#{feat_name.capitalize} performed! You have performed this #{feat_name}" +
    " #{feat_role.plays.count} times! #{others_text}"
  end

  def destroy_flash_notice
    "Delete Succesful! You have performed this #{performer.feat_name}" +
    " #{feat_role.plays.count} times!"
  end

  def feat_id
    feat.id
  end

  private

  def increment_feat_and_feat_roles_counter
    update_play_counters 1, created_at, created_at
  end

  def decrement_feat_and_feat_roles_counter
    feat_last_played = feat.plays.last.created_at
    feat_role_last_played = feat_role.plays.last.created_at
    update_play_counters -1, feat_last_played, feat_role_last_played
  end

  def update_play_counters(amount, feat_last_played, feat_role_last_played)
    feat_role.update(last_played_at: feat_role_last_played,
                     plays_count: feat_role.plays_count + amount)
    feat.update(last_played_at: feat_last_played,
                plays_count: feat.plays_count + amount)
  end
end
