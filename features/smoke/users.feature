Feature: Users smoke tests

  Scenario: Signup smoke test
    Given I am a new user
    When I visit the signup page
    And I enter my name
    And I enter my email
    And I enter my password
    And I confirm my password
    And I click "Create my Account"
    Then I should not see any validation errors
    When I note my user information
    Then I should not see an error flash
    And I should see a success flash
    And I should see "Please check your email to verify it."
    And I should be logged in
    When I verify my email
    Then I should see a success flash that says "Email verified"


