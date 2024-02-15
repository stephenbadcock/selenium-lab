*** Settings ***
Documentation    Resources for Infotiv car rental site tests
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${rental_site_url}    https://rental4.infotiv.net/
${browser}    Chrome
${user_email}    kungen@slottet.se
${user_password}    123456
${user_first_name}    Carl
${start_date}    0310
${end_date}    0315
${pickup_date}    2024-03-10
${car_id}    bookTTpass5
${car_model}    Audi TT
${card_number}    1234123412341234
${card_holder}    Carl XVI Gustaf Folke Hubertus Bernadotte
${card_expire_month}    11
${card_expire_year}    2025
${card_cvc}    888
${car_seating_capacity}    7
@{expected_license_numbers}
@{actual_license_numbers}

*** Keywords ***
Setup test environment
    [Documentation]    Open rental site with Chrome and log in on existing user account

    Set Selenium Speed    0
    Open Browser    ${rental_site_url}    ${browser}
    Maximize Browser Window
    Wait Until Element Is Visible    //input[@id='email']
    Input Text    //input[@id='email']    ${user_email}
    Input Password    //input[@id='password']    ${user_password}
    Click Button    //button[@id='login']

User is logged in and on date selection page
    [Documentation]    Check if user is logged in and on date selection page
    [Tags]    VG_test    date-selection
    
    Wait Until Page Contains    You are signed in as ${user_first_name}
    Wait Until Element Is Visible    //input[@id='start']

User selects rental period
    [Documentation]    Date selection - Choose rent period: ${start_date} - ${end_date}
    [Tags]    VG_test    user-input    navigation    booking    date-selection
    [Arguments]    ${start_date}    ${end_date}

    Click Element    //input[@id='start']
    Input Text    //input[@id='start']    text=${start_date}
    Click Element    //input[@id='end']
    Input Text    //input[@id='end']    text=${end_date}
    Click Button    //button[@id='continue']

User selects car
    [Documentation]    Car Selection - Fill in data needed to rent a ${car_model} with ID: ${car_id}
    [Tags]    VG_test    user-input    navigation    booking    car-selection
    [Arguments]    ${car_id}

    Wait Until Element Is Visible    //input[@id='${car_id}']
    Click Element    //input[@id='${car_id}']

User submits credit card info
    [Documentation]    Confirm Booking - Fill in credit card info and click 'Confirm'
    [Tags]    VG_test    user-input    navigation    booking    confirm-booking

    Wait Until Element Is Visible    //input[@id='cardNum']
    Click Element    //input[@id='cardNum']
    Input Text    //input[@id='cardNum']    text=${card_number}
    Click Element    //input[@id='fullName']
    Input Text    //input[@id='fullName']    text=${card_holder}
    Select From List By Label    //select[@title='Month']    ${card_expire_month}
    Select From List By Label    //select[@title='Year']    ${card_expire_year}
    Click Element    //input[@id='cvc']
    Input Text    //input[@id='cvc']    text=${card_cvc}
    Click Button    //button[@id='confirm']
    
A confirmation of the booking is shown    
    [Documentation]    Successful Booking - A confirmation of the booking is shown
    [Tags]    VG_test    booking    successful-booking

    Wait Until Page Contains    A ${car_model} is now ready for pickup ${pickup_date}

User filters cars by seating capacity
    [Documentation]    saves list of license plates for cars with seating capacity = ${car_seating_capacity} and user filters cars
    [Tags]    VG_test    booking    car-selection
    [Arguments]    ${car_seating_capacity}

    ${plate_elements}=    Get Webelements    xpath=//input[contains(@id, "pass${car_seating_capacity}")]/../input[@name="licenseNumber"]

    FOR    ${element}    IN    @{plate_elements}
        ${license_number}=    Get Element Attribute    ${element}    value
        Append To List    ${expected_license_numbers}    ${license_number}
        #Log To Console    ${plate}
    END

    Wait Until Element Is Visible    //div[@id='ms-list-2']//button[@type='button']
    Click Button    //div[@id='ms-list-2']//button[@type='button']
    Click Element   css=[data-search-term="${car_seating_capacity}"]
    Click Button    //div[@id='ms-list-2']//button[@type='button']

All available cars with selected seating capacity is shown
    [Documentation]    Compares expected cars with seating capacity = ${car_seating_capacity} to filtered
    [Tags]    VG_test    booking    car-selection

    Wait Until Page Contains Element    //div[@id='carSelection']
    ${plate_elements}=    Get Webelements    xpath=//input[@name="licenseNumber"]

    FOR    ${plate}    IN    @{plate_elements}
        ${license_number}=    Get Element Attribute    ${plate}    value
        Append To List    ${actual_license_numbers}    ${license_number}
        Log    ${license_number}
    END

    Lists Should Be Equal    ${actual_license_numbers}    ${expected_license_numbers}

Close test environment
    [Documentation]    Close Browser

    Click Button    //button[@id='logout']
    Close Browser
