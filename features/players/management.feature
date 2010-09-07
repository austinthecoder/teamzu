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