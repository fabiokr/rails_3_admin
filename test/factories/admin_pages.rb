Factory.define :page, :class => Admin::Page do |p|
  p.controller_path { Faker::Lorem.words.join(', ') }
  p.title           { Faker::Lorem.sentence }
  p.description     { Faker::Lorem.sentence }
  p.tags            { Faker::Lorem.words.join(', ') }
end
