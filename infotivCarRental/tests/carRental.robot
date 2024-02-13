*** Settings ***
Documentation    Tests for renting a car on Infotiv's car rental site
Library    SeleniumLibrary
Resource    resources/carRentalResources.robot
Suite Setup    Setup test environment
Suite Teardown    Close test environment

*** Test Cases ***
Book car
    Given User is logged in and on date selection page
    When User selects rental period and car    ${start_date}    ${end_date}    ${car_id}
    And User submits credit card info
    Then A confirmation of the booking is shown

