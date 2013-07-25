@javascript
Feature: baseline
  Scenario: I see the empty home page
    When I visit the homepage
    Then I should see the baseline page
