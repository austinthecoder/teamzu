Then /^I should see the user registration form$/ do
  page.should have_css("#user_new")
end

Then /^I should receive the welcome email$/ do
  p Rails.env
  p ActionMailer::Base.deliveries
end