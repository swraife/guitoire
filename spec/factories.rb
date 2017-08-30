FactoryGirl.define do
  factory :area do
  end

  factory :follow do
    association :performer, factory: :performer
    association :follower, factory: :performer
  end

  factory :griddler_email, class: OpenStruct do
    # Assumes Griddler.configure.to is :hash (default)
    to [{ full: 'to_user@performr.world', email: 'to_user@performr.world', token: 'to_user', host: 'performr.world', name: nil }]
    from({ token: 'from_user', host: 'email.com', email: 'from_email@email.com', full: 'From User <from_user@email.com>', name: 'From User' })
    subject 'email subject'
    body 'Hello!'
    attachments {[]}

    trait :with_attachment do
      attachments {[
        ActionDispatch::Http::UploadedFile.new({
          filename: 'img.jpeg',
          type: 'image/jpeg',
          tempfile: File.new("#{Rails.root}/app/assets/images/guitoire_logo.jpeg")
        })
      ]}
    end
  end

  factory :group do
    name 'Name'
    description 'Description'
  end

  factory :play do
    feat_role
    performer { feat_role.owner }
    feat { feat_role.feat }
  end

  factory :routine_role do
    user_id 1
    routine_id 1
    role 1
  end

  factory :note_resource do
  end

  factory :url_resource do
  end

  factory :file_resource do
  end

  factory :routine_feat do
    feat_id 1
    routine_id 1
  end

  factory :routine do
    name 'MyString'
    description 'MyString'
  end

  factory :event do
    name 'MyString'
    date '2016-12-18'
    routine_id 1
  end

  factory :resource do
    name 'MyString'
  end

  factory :composer do
    name 'MyString'
  end

  factory :feat do
    name 'Name'
    description 'MyText'
    music_key 'MyString'
    tempo 1
  end

  factory :feat_role do
    association :owner, factory: :performer
    feat
  end

  factory :user do
    first_name 'MyString'
    last_name 'MyString'
    sequence(:email) { |n| "email#{n}@test.org" }
    password 'password'
    password_confirmation 'password'
  end

  factory :performer do
    settings { { feat_name: 'trick', routine_name: 'act' } }
    user
    sequence(:username) { |n| "user#{n}" }
  end

  factory :message_thread do
  end

  factory :tag, class: ActsAsTaggableOn::Tag do |t|
    t.name 'Fly'
  end
end
