# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'creating users'
names = [%w(Jet Li), %w(John Wayne), %w(Lucy Lawless)]
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
User.each do |user|
  Performer.create(user: user)
end
puts 'performers created!'

puts 'creating feats'
feat_names = ['Cherokee Shuffle', 'Summertime', 'Golden Slippers']
feat_names.each do |name|
  Feat.where(name: name).first_or_create(name: name, creator: Performer.first)
end
puts 'feats created'