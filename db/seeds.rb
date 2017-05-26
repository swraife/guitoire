# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'creatings areas and skills'
area_skills = {
  'circus' => %w(juggling poi trapeze aerial_fabrics lyra straps
                          chains contact_juggling unicycling magic illusion
                          clowning mime acrobalance diabolo devil_sticks
                          staff rope),
  'extreme_sports'  => %w(skateboarding snowboarding skiing bmx slacklining wakeboarding kiteboarding),
  'music'  => %w(bluegrass folk jazz classical rock country blues rap
                 punk pop reggae metal world hip_hop),
  'other'  => []
}

area_skills.each do |area_name, skills|
  puts "Creating #{area_name}"
  area = Area.create(name: area_name)

  skills.each do |skill|
    Skill.create(name: skill, area: area)
    print '.'
  end
end

puts 'creating users'
names = [%w(Jet Li), %w(John Wayne), %w(Lucy Lawless), %w(Mo Rocco),
         %w(Al Capone), %w(Kim Possible), %w(Sally Goodin), %w(Shaun White),
         %w(Weird Al), %w(Taylor Swift), %w(Janet Jackson), %w(Al Green),
         %w(Frankie Munoz), %w(Bruce Lee), %w(John Glenn), %w(Count Olaf)]
names.each do |first, last|
  User.where(email: "#{first.downcase}@#{last.downcase}.com").first_or_create(
    first_name: first,
    last_name: last,
    password_confirmation: 'password',
    password: 'password',
  )
end
puts 'users created'

puts 'creating performers...'
User.all.each do |user|
  area = Area.find((user.id / 4.0).ceil)
  skill_ids = area.skill_ids.values_at(*[rand(1..10), rand(1..10), rand(1..10)].uniq.compact)
  Performer.create(user: user,
                   username: "#{user.first_name.downcase}_#{user.last_name.downcase}",
                   area: area,
                   public_name: user.public_name,
                   name: area.name,
                   standard_skill_ids: skill_ids,
                   settings: {feat_name: 'Skill', routine_name: 'Routine'})
end

Performer.create(user: User.find_by_email('shaun@white.com'),
                 username: 'shaun2',
                 area_id: 3,
                 public_name: 'Shaun White',
                 name: 'Music',
                 standard_skill_ids: ActsAsTaggableOn::Tag.find_by_name('punk').id,
                 settings: {feat_name: 'Song', routine_name: 'Set List'})
puts 'performers created!'

puts 'creating follows'
follow_ids = (1..50).each_with_object([]) { |_i, arr| arr.push([rand(1..16), rand(1..16)]) }.uniq
follow_ids.each do |ids|
  Follow.create(performer_id: ids[0], follower_id: ids[1]) unless ids[0] == ids[1]
end

puts 'creating feats'
feat_names = ['Backcrosses', 'Scary Drop', 'No Hands Trick', 'Flying',
              'Heelflip', 'Kickflip', '50-50', 'Varial Flip',
              'Jaybird', 'Summertime', 'Golden Slippers', 'June Apple',
              'Thing', 'Who Knows', 'Flying Monkey', 'Special']
feat_names.each_with_index do |name, index|
  performer_id = Area.find(((index + 1) / 4.0).ceil).performers.last.id
  Feat.where(name: name).first_or_create(name: name,
                                         creator_id: performer_id,
                                         owner_id: performer_id,
                                         owner_type: 'Performer',
                                         visibility: rand(0..1))
end

puts 'creating groups'
group_names = ['Ringley Bros', 'The Gnar Pow', 'Wu Tang Clan', 'Cat Power']
group_names.each_with_index do |name, index|
  area = Area.find(index + 1)
  Group.create(name: name,
               creator: area.performers.last,
               visibility: rand(0..1))
end
