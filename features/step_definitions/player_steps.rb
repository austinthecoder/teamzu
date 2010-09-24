Given /^that team has a player with the attributes:$/ do |table|
  attrs = table.rows_hash
  @player = @team.players.create!(:name => attrs['Name'], :email => attrs['Email'])
end

Given /^that team has players with the attributes:$/ do |table|
  @players = []
  table.hashes.each do |attrs|
    attrs2 = {}
    attrs.each { |k, v| attrs2[k.downcase.gsub(/\s/, '_')] = v }
    @players << @team.players.create!(attrs2)
  end
end

##################################################

When /^I add players to that team with the following attributes:$/ do |table|
  table.hashes.each do |attrs|
    steps %Q{
      When I go to the add player page for that team
      And I fill in the following:
       | Name  | #{attrs['Name']}  |
       | Email | #{attrs['Email']} |
      And I press "Add Player"
    }
  end
end

When /^I follow "([^"]*)" within that player's row$/ do |link_text|
  within("tr#player_#{@player.id}") do
    click_link(link_text)
  end
end

When /^I check those players in the table$/ do
  within("table.players") do
    @players.each do |p|
      check("player_id_#{p.id}")
    end
  end
end

##################################################

Then /^I should see the add player form$/ do
  page.should have_css("form#new_player")
end

Then /^I should see the player's table with the following rows:$/ do |table|
  table.diff!(tableish("#team_#{@team.id} .players tr", 'th, td'))
end