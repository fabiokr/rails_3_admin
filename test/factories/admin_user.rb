Factory.define :admin_user, :class => AdminUser do |p|
  p.email                 { Faker::Internet.email }
  p.password              '123456'
  p.password_confirmation '123456'
end
