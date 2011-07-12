Factory.define :user do |f|
  f.name "bob"
end

Factory.define :page do |f|
  f.title "Page title"
  f.body "Lorem ipsum dolor sit amet, ..."
  f.association :user
end

Factory.define :comment do |f|
  f.body "Lorem ipsum dolor sit amet, ..."
  f.association :page
  f.user { |c| c.page.user }
end
