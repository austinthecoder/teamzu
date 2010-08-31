Feature: Teams table

  Scenario: Table
    Given I am signed in
    
    When I go to the home page
    And I follow "My Teams"
    Then I should see "You do not have any teams."
    
    When I create teams with the following attributes:
      | Name     |
      | Strikers |
      | Falcons  |
    Then the teams table should look like:
      | Name     |
      | Falcons  |
      | Strikers |
  
  ##################################################
  
  Scenario: Pagination
    Given I am signed in
    And I have "30" teams
    
    When I go to the teams page
    Then I should see "20" teams
    
    When I follow "Next"
    Then I should see "10" teams