Factory.define :page_content, :class => Admin::PageContent do |c|
  c.association :page
  c.key         'body'
  c.content     { Faker::Lorem.paragraphs.join(' ') }
end
