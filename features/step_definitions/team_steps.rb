Given /^I have a team with the name "([^"]*)"$/ do |name|
  @team = @user.teams.create!(:name => name)
end

Given /^I have a team$/ do
  Given %|I have a team with the name "Lakers"|
end

Given /^I have "([^"]*)" teams$/ do |num|
  num.to_i.times do
    Given %|I have a team with the name "#{Factory.next(:team_name)}"|
  end
end

##################################################

When /^I create teams with the following attributes:$/ do |table|
  table.hashes.each do |attrs|
    When %|I create a team with the name "#{attrs['Name']}"|
  end
end

When /^I create a team with the name "([^"]*)"$/ do |name|
  steps %Q{
    When I go to the new team page
    And I fill in the following:
      | Name | #{name} |
    And I press "Create my team"
  }
end

When /^I follow "([^"]*)" for the team named "([^"]*)"$/ do |link_title, team_name|
  team = @user.teams.find_by_name(team_name)
  within("#teams tr#team_#{team.id}") do
    click(link_title)
  end
end

##################################################

Then /^I should see the new team form$/ do
  page.should have_css("form#new_team")
end

Then /^I should see the edit team form$/ do
  page.should have_css("form.edit_team")
end

Then /^I should see the delete team form$/ do
  page.should have_css("form.delete_team")
end

Then /^the teams table should look like:$/ do |table|
  table.diff!(tableish('#teams tr', 'th, td'))
end

Then /^I should see "([^"]*)" teams$/ do |num|
  within("#teams") do
    all("tbody tr").size.should == num.to_i
  end
end