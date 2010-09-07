Then /^I should see the add player form$/ do
  page.should have_css("form#new_player")
end