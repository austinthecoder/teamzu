Given /^there is a user with the following attributes:$/ do |table|
  attrs = table.rows_hash
  @user_password = attrs['Password']
  @user = User.create!(
    :email => attrs['Email'],
    :password => @user_password,
    :password_confirmation => @user_password
  )
end

Given /^I am signed in$/ do
  steps %Q{
    Given there is a user with the following attributes:
      | Email    | john@example.com |
      | Password | 222222           |
    And I sign in with "john@example.com" and "222222"
  }
end

Given /^I am signed in as that user$/ do
  And %|I sign in with "#{@user.email}" and "#{@user_password}"|
end

##################################################

When /^I follow "([^"]*)" in that email$/ do |link_title|
  url = @mail.body.to_s.scan(/<a\shref="([^"]*)"\>#{link_title}/).flatten.first
  visit(url)
end

When /^I sign in with "([^"]*)" and "([^"]*)"$/ do |email, password|
  steps %Q{
    When I go to the home page
    And I follow "Sign In"
    And I fill in the following:
      | Email    | #{email}    |
      | Password | #{password} |
    And I press "Sign in"
  }
end

##################################################

Then /^I should see the sign in form$/ do
  page.should have_css("form#sign_in")
end

Then /^I should see the sign up form$/ do
  page.should have_css("form#sign_up")
end

Then /^I should see the forgot password form$/ do
  page.should have_css("form#forgot_password")
end

Then /^I should see the change your password form$/ do
  page.should have_css("form#change_password")
end

Then /^I should see the edit user form$/ do
  page.should have_css("form#user_edit")
end

Then /^I should see the account cancellation form$/ do
  page.should have_css("form#delete_user")
end

Then /^I should (not\s)?see the signed\-in menu$/ do |the_not|
  assertion = the_not.blank? ? :should : :should_not
  within("#user_menu") do
    page.send(assertion, have_content("My Account"))
    page.send(assertion, have_content("My Teams"))
    page.send(assertion, have_content("Sign Out"))
  end
end

Then /^I should receive the reset password instructions with the attributes:$/ do |table|
  attrs = table.rows_hash
  @mail = ActionMailer::Base.deliveries.last
  @mail.subject.should == attrs['Subject']
  @mail.to.should == [attrs['To']]
end

Then /^I should be signed in$/ do
  steps %Q{
    Then I should see "Welcome back!"
    And I should see the signed-in menu
  }
end