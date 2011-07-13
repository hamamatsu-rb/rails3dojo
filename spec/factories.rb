Factory.define :user do |f|
  f.name "bob"
end

Factory.sequence :page_title do |n|
  "Page #{n}"
end

Factory.define :page do |f|
  f.title { Factory.next(:page_title) }
  f.body "Lorem ipsum dolor sit amet, ..."
  f.association :user
end

Factory.define :comment do |f|
  f.body "Lorem ipsum dolor sit amet, ..."
  f.association :page
  f.user { |c| c.page.user }
end

Factory.define :history do |f|
  f.association :page
  f.user { |c| c.page.user }
end
