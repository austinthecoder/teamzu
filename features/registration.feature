Feature: Registration
  
  Scenario: Signing up
    When I go to the home page
    And I follow "Sign Up"
    Then I should see the user registration form
    
    When I fill in the following:
      | Email                 | austin@example.com |
      | Password              | 111111             |
      | Password confirmation | 111111             |
    And I press "Sign up"
    Then I should see "You have signed up successfully."