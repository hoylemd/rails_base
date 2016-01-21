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
    Then I should not see any validation errors
    And I should see a success flash
    And I should see "Please check your email to verify it."
    And I should be logged in

  @skip
  Scenario: User is unverified after signup
    When I sign up
    And I remember my user id
    And I visit the users page
    Then I should see a permission denied flash message
    When I visit my profile page
    And I click "dev verify"
    Then I should se a success flash message that says "Email verified"

@skip
  Scenario: All signup fields are present
    Then I should see a "Email" field
    And I should see a "Password" field
    And I should see a "Confirmation" field
    And I should see a "Bio" field

@skip
  Scenario: Omit all fields
    When I click "Create my account"
    Then I should see an validation error that says "Email can't be blank"
    And I should see an validation error that says "Password can't be blank"
    And I should see an validation error that says "Password is too short (minimum is 6 characters)"

@skip
  Scenario: Signup with duplicate email
    When I complete the signup form
    And I click "Log Out"
    And I visit the signup page
    And I enter my email into "Email"
    And I enter a random password
    And I confirm my password
    And I click "Create my account"
    Then I should see an validation error that says "Email has already been taken"

@skip
  Scenario: Signup with bad passwords
    When I enter a random email
    And I enter a random password
    And I confirm my password incorrectly
    And I click "Create my account"
    Then I should see an validation error that says "Password confirmation doesn't match Password"
    When I enter a random short password
    And I confirm my password
    And I click "Create my account"
    Then I should see an validation error that says "Password is too short (minimum is 6 characters)"
