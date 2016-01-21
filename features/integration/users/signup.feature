Feature: Signup

  Background:
    Given I am a new user
    And I am on the signup page

  @smoke
  Scenario: Normal signup flow
    When I enter a random name
    And I enter a random email
    And I enter a random password
    And I confirm my password
    And I click "Create my Account"
    And I note my user information
    Then I should not see any validation errors
    And I should see a success flash
    And I should see "Please check your email to verify it."
    And I should be logged in
    When I verify my email
    Then I should see a success flash that says "Email verified"

  Scenario: User is unverified after signup
    When I sign up
    And I visit the users page
    Then I should see a permission denied flash message
    When I verify my email
    Then I should see a success flash that says "Email verified"
    When I visit the users page
    Then I should not see an error flash
    And I should see the following phrases:
      | Leia Organa |
      | Darth Vader |
    And I should not see "Barack Obama"

  Scenario: Omit all fields
    When I click "Create my Account"
    Then I should see the following validation errors:
      | Name can't be blank |
      | Email can't be blank |
      | Password can't be blank |

  @skip
  Scenario: Signup with duplicate email
    When I complete the signup form
    And I click "Log Out"
    And I visit the signup page
    And I enter my email into "Email"
    And I enter a random password
    And I confirm my password
    And I click "Create my Account"
    Then I should see a validation error that says "Email has already been taken"

  @skip
  Scenario: Signup with bad passwords
    When I enter a random email
    And I enter a random password
    And I confirm my password incorrectly
    And I click "Create my Account"
    Then I should see a validation error that says "Password confirmation doesn't match Password"
    When I enter a random short password
    And I confirm my password
    And I click "Create my Account"
    Then I should see a validation error that says "Password is too short (minimum is 6 characters)"
