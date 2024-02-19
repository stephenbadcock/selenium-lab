*** Settings ***
Documentation    Tests for Infotiv's car rental site
Resource    resources/carRentalResources.robot
Suite Setup    Setup test environment
Suite Teardown    Close test environment

*** Test Cases ***
Scenario: Book car
    Given User is on date selection page
    When User logs in with valid credentials    ${valid_user_email}    ${valid_user_password}    ${user_first_name}
    And User selects rental period    ${start_date}    ${end_date}
    And User selects car    ${car_id}
    And User submits credit card info    ${card_number}    ${card_holder}    ${card_expire_month}    ${card_expire_year}    ${card_cvc}
    Then A confirmation of the booking is shown    ${car_model}    ${pickup_date}

Scenario: Unsuccessful login attempt
    Given User is on date selection page
    When User logs in with invalid credentials    ${invalid_user_email}    ${invalid_user_password}
    Then An error message appears to the left of the buttons

Scenario: Filter available cars by seating capacity
    Given User is on date selection page
    When User selects rental period    ${start_date}    ${end_date}
    And User filters cars by seating capacity    ${car_seating_capacity}
    Then All available cars with selected seating capacity is shown    ${expected_license_numbers}

Scenario: Check if filtered cars are bookable
    Given User is on date selection page
    When User selects rental period    ${start_date}    ${end_date}
    And User filters cars by seating capacity    ${car_seating_capacity}
    Then A book button is shown besides all available cars

Scenario: Unbook a car
    Given User is logged in and on date selection page
    When User selects rental period    ${start_date}    ${end_date}
    And User selects car    ${car_id}
    And User submits credit card info    ${card_number}    ${card_holder}    ${card_expire_month}    ${card_expire_year}    ${card_cvc}
    And User cancels booking on 'My page'
    Then A confirmation of the cancellation is shown
