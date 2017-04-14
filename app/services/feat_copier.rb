class FeatCopier
  attr_accessor :feat, :feat_copy, :copy_creator

  def initialize(feat:, copy_creator:)
    @feat = feat
    @copy_creator = copy_creator
  end

  def copy!
    attributes = feat.attributes.slice(
      'name', 'description', 'music_key', 'scale', 'time_signature', 'tempo'
    )
    self.feat_copy = Feat.create!(
      attributes.merge(creator: copy_creator,
                       owner: copy_creator,
                       version_list: feat.version_list,
                       generic_list: feat.generic_list,
                       composer_list: feat.composer_list)
    )

    feat.resources.each do |resource|
      Resource.create!(target: feat_copy,
                       resourceable: resource.resourceable,
                       creator: copy_creator)
    end
    feat_copy
  end
end
