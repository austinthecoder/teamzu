Feature: Team Management
  
  Scenario: Creating team
    Given I am signed in
    
    When I go to the home page
    And I follow "My Teams"
    And I follow "Create a team"
    Then I should see the new team form
    
    When I press "Create my team"
    Then I should see "Name can't be blank"
    
    When I fill in "Name" with "Strikers"
    And I press "Create my team"
    Then I should see "Team was created"
  
  ##################################################
  
  Scenario: Edit team
    Given I am signed in
    And I have a team with the name "Strikers"
    
    When I go to the teams page
    And I follow "edit" for the team named "Strikers"
    Then I should see the edit team form
    
    When I fill in "Name" with ""
    When I press "Save team"
    Then I should see "Name can't be blank"
    
    When I fill in "Name" with "Strikers"
    And I press "Save team"
    Then I should see "Team was saved"
  
  ##################################################
  
  Scenario: Delete team
    Given I am signed in
    And I have a team with the name "Strikers"

    When I go to the teams page
    And I follow "delete" for the team named "Strikers"
    Then I should see the delete team form

    When I press "Yes, delete this team"
    Then I should see "Team was deleted"