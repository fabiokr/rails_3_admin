# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :page_content do |c|
  c.association :page
  c.key         'body'
  c.content     { Faker::Lorem.paragraphs.join(' ') }
end
