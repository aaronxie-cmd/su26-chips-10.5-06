Feature: ActionMap Shows State and County Maps

  Scenario: Navigating from the national map to a state
    Given I am on the homepage
    Then I should see "National Map"
    When I click the state "CA"
    Then I should see "California"
    And I should be on the state page for "CA"

  @javascript
  Scenario: California map renders Alameda County
    Given I visit the state page for "CA"
    Then I should see the county "Alameda"

  Scenario: Viewing representatives from a county
    Given I visit the county page for "CA" with FIPS code "001"
    Then I should see "Alameda"
    And I should see "Representatives for Alameda County"
    And I should see "Jane Doe"
    And I should see "Back to California"