FactoryGirl.define do
  factory :area do
  end

  factory :friendship do
    association :connector, factory: :performer
    association :connected, factory: :performer

    factory :accepted_friendship do
      status 2
      after(:create) do |friendship, evaluator|
        friendship.send(:create_accepted_activity)
      end
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
    music_key 'MyString'
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
  end

  factory :message_thread do
  end

  factory :tag, class: ActsAsTaggableOn::Tag do |t|
    t.name 'Fly'
  end
end
