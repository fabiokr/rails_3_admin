Factory.define :page do |p|
  p.title       { Faker::Lorem.sentence }
  p.description { Faker::Lorem.sentence }
  p.tags        { Faker::Lorem.words.join(', ') }
end
