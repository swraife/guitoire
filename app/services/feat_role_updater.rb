class FeatRoleUpdater
  attr_reader :feat, :admin_performer_ids, :admin_group_ids

  def initialize(feat, admin_performer_ids, admin_group_ids)
    @feat = feat
    @admin_performer_ids = format_ids(admin_performer_ids)
    @admin_group_ids = format_ids(admin_group_ids)
    add_feat_owner
  end

  def update!
    FeatRole.admin.where(feat: feat).each do |feat_role|
      next if (admin_performer_ids.include?(feat_role.owner_id) && feat_role.owner_type == 'Performer')
      next if (admin_group_ids.include?(feat_role.owner_id) && feat_role.owner_type == 'Group')
      feat_role.destroy!
    end

    {'Performer' => admin_performer_ids, 'Group' => admin_group_ids}.each do |k, v|
      v.each do |owner_id|
        FeatRole.where(feat: feat, owner_id: owner_id, owner_type: k)
          .first_or_initialize.admin!
      end
    end
  end

  private

  def add_feat_owner
    admin_performer_ids.push(feat.owner_id) if feat.owner_type == 'Performer'
    admin_group_ids.push(feat.owner_id) if feat.owner_type == 'Group'
  end

  def format_ids(ids)
    ids.reject(&:blank?).map(&:to_i)
  end
end
