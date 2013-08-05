@javascript
Feature: A user should be able to see the most recent blog posts summarized on the site.

  Scenario: Users on the home page should see the latest entries
    Given there are some published posts
    When I visit the site
    Then I should see the posts
    And they should be in reverse chronological order
