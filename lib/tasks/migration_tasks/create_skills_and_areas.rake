desc 'create skills and areas'

task create_skills_and_areas: :environment do
  area_skills = {
    'circus' => %w(juggling poi trapeze aerial_fabrics lyra straps
                            chains contact_juggling unicycling magic illusion
                            clowning mime acrobalance diabolo devil_sticks
                            staff rope),
    'dance'  => %w(ballet swing tap modern_dance),
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
end
