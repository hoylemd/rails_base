Feature: home page

  Background:
    Given I am viewing the app

  @smoke
  Scenario: Home page, unauthenticated
    Then I should see "Welcome to the Sample App"
    And The page title should be "Ruby on Rails Tutorial Sample App"
    And I should see 2 links to the signup page
    And I should see 2 links to the home page
    And I should see a link to the help page
    And I should see a link to the about page
    And I should see a link to the contact page
    And I should not see a link to the users page
    And I should not see a link to the logout page
