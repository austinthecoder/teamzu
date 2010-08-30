Feature: Account

  Scenario: Basic Editing
    Given there is a user with the following attributes:
      | Email    | john@example.com |
      | Password | 222222           |
    And I am signed in as that user
    
    When I follow "My Account"
    Then I should see the edit user form
    
    When I fill in the following:
      | Email | xyz@example.com |
    When I press "Update"
    Then I should see "Current password can't be blank"
    
    When I fill in the following:
      | Email            |        |
      | Current password | 222222 |
    When I press "Update"
    Then I should see "Email can't be blank"
    
    When I fill in the following:
      | Email            | xyz@example.com |
      | Current password | 222222          |
    And I press "Update"
    Then I should see "You updated your account successfully."
  
  ##################################################
  
  Scenario: Changing Password
    Given there is a user with the following attributes:
      | Email    | john@example.com |
      | Password | 222222           |
    And I am signed in as that user
    
    When I follow "My Account"
    And I fill in the following:
      | Password         | 333333 |
      | Current password | 222222 |
    And I press "Update"
    Then I should see "Password doesn't match confirmation"
    
    When I fill in the following:
      | Password              | 333333 |
      | Password confirmation | 333333 |
      | Current password      | 222222 |
    And I press "Update"
    Then I should see "You updated your account successfully."
  
  ##################################################
  
  Scenario: Canceling
    Given I am signed in
    
    When I follow "My Account"
    And I follow "Cancel my account"
    Then I should see the account cancellation form
    
    When I press "Yes, cancel my account"
    Then I should see "Your account was cancelled. We hope to see you again soon."