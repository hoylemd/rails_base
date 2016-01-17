Feature: home page

  Background:
    Given I am viewing the app

  @smoke
  Scenario: Home page, unauthenticated
    Then I should see "Welcome to the Sample App"
