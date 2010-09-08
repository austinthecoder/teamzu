Feature: Player Management

  Scenario: Adding players to a team
    Given I am signed in
    And I have a team
    And I am on that team's page
    
    When I follow "Add a player"
    Then I should see the add player form
    
    When I press "Add Player"
    Then I should see "Name can't be blank"
    And I should see the add player form
    
    When I fill in the following:
     | Name  | John Smith     |
     | Email | js@example.com |
    And I press "Add Player"
    Then I should see "Player was added."
  
  ##################################################
  
  Scenario: Viewing players for a team
    Given I am signed in
    And I have a team
    
    When I go to that team's page
    Then I should see "This team does not have any players."
    
    When I add players to that team with the following attributes:
      | Name        | Email          |
      | John Smith  | js@example.com |
      | Sue Johnson | sj@example.com |
    And I go to that team's page
    Then I should see the player's table with the following rows:
      | Name        | Email          |
      | Sue Johnson | sj@example.com |
      | John Smith  | js@example.com |
  
  ##################################################
  
  Scenario: Removing players from a team
    Given I am signed in
    And I have a team
    And that team has a player with the attributes:
      | Name | Steve Jobs |
    
    When I go to that team's page
    And I follow "remove" within that player's row
    Then I should see "Are you sure you want to remove this player from the team?"
    
    When I press "Yes, remove player"
    Then I should see "Player was removed."
    And I should see "This team does not have any players."
  
  ##################################################
  
  Scenario: Editing players for a team
    Given I am signed in
    And I have a team
    And that team has a player with the attributes:
      | Name | Steve Jobs |
    
    When I go to that team's page
    And I follow "edit" within that player's row
    Then I should see "Editing Player"
    
    When I fill in "Name" with ""
    And I press "Save player"
    Then I should see "Name can't be blank"
    
    When I fill in the following:
     | Name  | John Jobs      |
     | Email | jj@example.com |
    And I press "Save player"
    Then I should see "Player was saved."
    