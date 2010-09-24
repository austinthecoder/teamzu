Feature: Notifications

  Scenario: Emailing players
    Given I am signed in
    And I have a team
    And that team has players with the attributes:
      | Name        | Email          |
      | John Smith  | js@example.com |
      | Sue Johnson | sj@example.com |

    When I go to that team's page
    And I check those players in the table
    And I select "Send Email" from "with selected"
    And I press "Go"
    Then I should see "Send Email to Players"

    When I fill in the following:
      | Subject | Game Tomorrow                    |
      | Message | We have a game tomorrow at 8:00. |
    And I press "Send"

    Then I should see "Email was sent"
    And those players should receive that email