*** Settings ***
Documentation    Tests for Infotiv's car rental site
Library    SeleniumLibrary
Resource    resources/carRentalResources.robot
Suite Setup    Setup test environment
Suite Teardown    Close test environment

*** Test Cases ***
Book car
    Given User is logged in and on date selection page
    When User selects rental period    ${start_date}    ${end_date}
    And User selects car    ${car_id}
    And User submits credit card info
    Then A confirmation of the booking is shown

Filter available cars by passengers
    Given User is logged in and on date selection page
    And User selects rental period    ${start_date}    ${end_date}
    When User filters cars by seating capacity    ${car_seating_capacity}
    Then All available cars with selected seating capacity is shown

