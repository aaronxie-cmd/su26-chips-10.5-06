Feature: Representative profile

  Scenario: Viewing a representative with complete information
    Given a representative exists with complete profile information
    When I visit that representative's profile
    Then I should see "Jane Doe"
    And I should see "Democrat"
    And I should see "202-225-0000"
    And I should see "123 Main Street"
    And I should see "https://doe.house.gov"

  Scenario: Viewing a representative with missing optional information
    Given a representative exists with missing profile information
    When I visit that representative's profile
    Then I should see "John Smith"
    And I should see "Not available"