Feature: User layouts

  Scenario: Signup form contains all fields
    When I visit the signup page
    Then I should see a "Name" field
    And I should see a "Email" field
    And I should see a "Password" field
    And I should see a "Confirmation" field
    And I should see a "Create my Account" button
