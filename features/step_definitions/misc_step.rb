Given /^the environment is "([^"]*)"$/ do |environment|
  Rails.env = environment
end