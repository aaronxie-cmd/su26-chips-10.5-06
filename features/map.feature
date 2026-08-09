Feature: ActionMap Shows State and County Maps

Scenario: Navigating States and counties
  Given I am on the homepage
  Then I should see "National Map"
  When I click the state "CA"
  Then I should see "California"
  And I should be on the state page for "CA"

@javascript
Scenario: California map renders Alameda County
  Given I am on the state page for "CA"
  Then I should see the county "Alameda"

Scenario: Viewing a county page
  Given I am on the county page for "CA" and FIPS code "001"
  Then I should see "Alameda"
  And I should see "Representatives for Alameda County"
  And I should see "Back to California"