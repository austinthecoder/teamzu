Feature: Registration
  
  Scenario: Signing up
    When I go to the home page
    And I follow "Sign Up"
    Then I should see the sign up form
    
    When I fill in the following:
      | Email                 | austin@example.com |
      | Password              | 111111             |
    And I press "Sign up"
    Then I should see "Password doesn't match confirmation"
    
    When I fill in the following:
      | Password              | 111111             |
      | Password confirmation | 111111             |
    And I press "Sign up"
    Then I should see "Thanks for signing up! You are now logged in."
    And I should see the signed-in menu
  
  ##################################################
  
  Scenario: Signing in
    Given there is a user with the following attributes:
      | Email    | john@example.com |
      | Password | 222222           |
    
    When I go to the home page
    And I follow "Sign In"
    Then I should see the sign in form
    
    When I fill in the following:
      | Email    | john@example.com |
      | Password | 333333           |
    And I press "Sign in"
    Then I should see "Invalid email or password."
    
    When I fill in the following:
      | Password | 222222           |
    And I press "Sign in"
    Then I should be signed in
  
  ##################################################
  
  Scenario: Signing out
    Given I am signed in
    
    When I go to the home page
    And I follow "Sign Out"
    Then I should see "See you next time!"
    And I should not see the signed-in menu
  
  ##################################################
  
  Scenario: Forgot password
    Given there is a user with the following attributes:
      | Email    | john@example.com |
      | Password | 222222           |
    
    When I go to the home page
    And I follow "Sign In"
    And I follow "Forgot?"
    Then I should see the forgot password form
    
    When I press "Send me reset password instructions"
    Then I should see "Email can't be blank"
    
    When I fill in "Email" with "john@example.com"
    And I press "Send me reset password instructions"
    Then I should see "You will receive an email with instructions about how to reset your password in a few minutes."
    And I should receive the reset password instructions with the attributes:
      | To      | john@example.com            |
      | Subject | Reset password instructions |
    
    When I follow "Change my password" in that email
    Then I should see the change your password form
    
    When I fill in the following:
      | Password              | 444444 |
    And I press "Change my password"
    Then I should see "Password doesn't match confirmation"
    
    When I fill in the following:
      | Password              | 444444 |
      | Password confirmation | 444444 |
    And I press "Change my password"
    Then I should see "Your password was changed successfully. You are now signed in."
    
    When I follow "Sign Out"
    And I sign in with "john@example.com" and "444444"
    Then I should be signed in