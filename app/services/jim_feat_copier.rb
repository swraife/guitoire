class JimFeatCreator
  def self.create_feats
    entries = Dir.entries('public/jim_feats')
      .delete_if { |item| ['.','..'].include?(item) }

    jim_feat_path = Rails.root.join('public/jim_feats/')

    ActiveRecord::Base.transaction do
      entries.each do |file_name|
        puts "creating #{file_name}"
        feat = Feat.where(user_id: 2, name: file_name.split('.')[0])
                   .first_or_initialize
        feat.persisted? ? next : feat.save!

        path = jim_feat_path + file_name
        file_resource = FileResource.new(main: File.new(path, 'r'))

        Resource.create!(
          target: feat, resourceable: file_resource
        )
      end
    end

  rescue ActiveRecord::ActiveRecordError => exception
    @errors = exception
    puts @errors    
  end
end