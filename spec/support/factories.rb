Factory.sequence(:email) { |n| "user#{n}@example.com" }
Factory.sequence(:team_name) { |n| "Team #{n}" }

##################################################

Factory.define(:user) do |m|
  m.email { Factory.next(:email) }
  m.password '111111'
  m.password_confirmation '111111'
end

Factory.define(:team) do |m|
  m.association :user
  m.name { Factory.next(:team_name) }
end