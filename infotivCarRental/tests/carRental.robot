*** Settings ***
Documentation    Tests for Infotiv's car rental site
Resource    resources/carRentalResources.robot
Suite Setup    Setup test environment
Suite Teardown    Close test environment

*** Test Cases ***
Scenario: Book car
    Given User is on date selection page
    When User logs in with valid credentials    ${valid_user_email}    ${valid_user_password}    ${user_first_name}
    And User selects rental period    ${days_until_pickup}    ${days_until_return}
    And User selects car    ${license_number}
    And User submits credit card info    ${card_number}    ${card_holder}    ${card_expire_month}    ${card_expire_year}    ${card_cvc}
    Then A confirmation of the booking is shown    ${car_model}    ${pickup_date}

Scenario: Unsuccessful login attempt
    Given User is on date selection page
    When User logs in with invalid credentials    ${invalid_user_email}    ${invalid_user_password}
    Then An error message appears to the left of the buttons

Scenario: User tries to book car without being logged in
    Given User is on date selection page
    When User selects rental period    ${days_until_pickup}    ${days_until_return}
    And User selects car    ${license_number2}
    Then An error message appears on the page

Scenario: Unbook a car
    Given User is on date selection page
    When User logs in with valid credentials    ${valid_user_email}    ${valid_user_password}    ${user_first_name}
    And User selects rental period    ${days_until_pickup}    ${days_until_return}
    And User selects car    ${license_number2}
    And User submits credit card info    ${card_number}    ${card_holder}    ${card_expire_month}    ${card_expire_year}    ${card_cvc}
    And User cancels booking on 'My page'    ${license_number2}
    Then A confirmation of the cancellation is shown    ${license_number2}

Scenario: Filter available cars by seating capacity
    Given User is on date selection page
    When User selects rental period    ${days_until_pickup}    ${days_until_return}
    And User filters cars by seating capacity    ${car_seating_capacity}
    Then All available cars with selected seating capacity is shown    ${expected_license_numbers}

Scenario: Check if filtered cars are bookable
    Given User is on date selection page
    When User selects rental period    ${days_until_pickup}    ${days_until_return}
    And User filters cars by seating capacity    ${car_seating_capacity}
    Then A book button is shown next to all available cars
