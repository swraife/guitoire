FactoryGirl.define do
  factory :routine_role do
    user_id 1
    set_list_id 1
    role 1
  end

  factory :note_resource do
  end

  factory :url_resource do
  end

  factory :file_resource do
  end

  factory :set_list_song do
    song_id 1
    set_list_id 1
    music_key 'MyString'
  end

  factory :routine do
    name 'MyString'
    description 'MyString'
  end

  factory :event do
    name 'MyString'
    date '2016-12-18'
    set_list_id 1
  end

  factory :resource do
    name 'MyString'
  end

  factory :composer do
    name 'MyString'
  end

  factory :song do
    name 'MyString'
    description 'MyText'
    music_key 'MyString'
    tempo 1
  end

  factory :user do
    first_name 'MyString'
    last_name 'MyString'
    sequence(:email) { |n| "email#{n}@test.org" }
    password 'password'
    password_confirmation 'password'
  end

  factory :message_thread do
  end
end
