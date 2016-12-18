FactoryGirl.define do
  factory :song_resource do
    song_id 1
    resource_id 1
  end
  factory :resource do
    name "MyString"
  end
  factory :composer do
    name "MyString"
  end
  factory :song do
    name "MyString"
    description "MyText"
    music_key "MyString"
    tempo 1
    composer_id 1
  end
  factory :user do
    first_name "MyString"
    last_name "MyString"
  end
end
