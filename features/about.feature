@javascript
Feature: About page

  Scenario: Users should be able to read about the site
    When I visit the site
    And I click the "About" navigation entry
    Then I should see the about page
