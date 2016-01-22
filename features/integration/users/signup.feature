Feature: Signup
  Background:
    Given I am a new user
    And I am on the signup page

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

  Scenario: Signup with duplicate email
    When I complete the signup form
    And I log out
    And I visit the signup page
    And I enter my email
    And I enter my password
    And I confirm my password
    And I click "Create my Account"
    Then I should see a validation error that says "Email has already been taken"

  Scenario: Signup with bad email
    When I enter my name
    And I enter my password
    And I enter gibberish into "Email"
    And I confirm my password
    And I click "Create my Account"
    Then I should see a validation error that says "Email is invalid"
    Then I should not see a validation error that says "Name can't be blank"

  Scenario: Signup with bad passwords
    When I enter my name
    And I enter my email
    And I enter my password
    And I confirm my password incorrectly
    And I click "Create my Account"
    Then I should see a validation error that says "Password confirmation doesn't match Password"
    When I enter "pass" into "Password"
    And I enter "pass" into "Confirmation"
    And I click "Create my Account"
    Then I should see a validation error that says "Password is too short (minimum is 8 characters)"

