*** Settings ***
Documentation    Resources for Infotiv car rental site tests
Library    SeleniumLibrary
Library    Collections
Library    DateTime

*** Variables ***
${rental_site_url}    https://rental4.infotiv.net/
${browser}    Chrome
${valid_user_email}    kungen@slottet.se
${valid_user_password}    123456
${invalid_user_email}    drottningen@slottet.se
${invalid_user_password}    abcdef
${user_first_name}    Carl
${days_until_pickup}    1
#${days_until_pickup2}    2
${days_until_return}    8
${pickup_date}
${license_number}    DHW439
${license_number2}    CEA328
${car_model}    Audi TT
${card_number}    1234123412341234
${card_holder}    Carl XVI Gustaf Folke Hubertus Bernadotte
${card_expire_month}    11
${card_expire_year}    2025
${card_cvc}    888
#${car_make}    Audi
${car_seating_capacity}    7
@{expected_license_numbers}
@{actual_license_numbers}

*** Keywords ***
Setup test environment
    [Documentation]    Open ${rental_site_url} with ${browser} and maximize browser window

    Set Selenium Speed    0
    Open Browser    ${rental_site_url}    ${browser}
    Maximize Browser Window

User is on date selection page
    [Documentation]    Date selection - Checks if user is on date selection page and XXX
    [Tags]    VG_test    date-selection

    Wait Until Page Contains    When do you want to make your trip?
    Wait Until Element Is Visible    //input[@id='email']

User logs in with valid credentials
    [Documentation]    Header - User logs in with valid credentials
    [Tags]    VG_test    header    login
    [Arguments]    ${user_email}    ${user_password}    ${user_first_name}

    Input Text    //input[@id='email']    ${user_email}
    Input Password    //input[@id='password']    ${user_password}
    Click Button    //button[@id='login']
    Wait Until Page Contains    You are signed in as ${user_first_name}
    
User selects rental period
    [Documentation]    Date selection - Choose rent period
    [Tags]    VG_test    user-input    booking    date-selection
    [Arguments]    ${days_until_pickup}    ${days_until_return}

    ${pickup_date}=    Get Current Date    increment=${days_until_pickup} days    result_format=%Y-%m-%d
    ${start_date_MMDD}=    Convert Date    ${pickup_date}    result_format=%m%d
    ${end_date_MMDD}=    Get Current Date    increment=${days_until_return} days    result_format=%m%d

    Wait Until Element Is Visible    //input[@id='start']
    Click Element    //input[@id='start']
    Input Text    //input[@id='start']    ${start_date_MMDD}
    Click Element    //input[@id='end']
    Input Text    //input[@id='end']    ${end_date_MMDD}
    Click Button    //button[@id='continue']

User selects car
    [Documentation]    Car Selection - Fill in data needed to rent a ${car_model} with license number ${license_number}
    [Tags]    VG_test    user-input    booking    car-selection
    [Arguments]    ${license_number}

    Wait Until Element Is Visible    //input[@value='${license_number}']/../input[@value='Book']
    Click Element    //input[@value='${license_number}']/../input[@value='Book']

User submits credit card info
    [Documentation]    Confirm Booking - Fill in credit card info and click 'Confirm'
    [Tags]    VG_test    user-input    booking    confirm-booking
    [Arguments]    ${card_number}    ${card_holder}    ${card_expire_month}    ${card_expire_year}    ${card_cvc}

    Wait Until Element Is Visible    //input[@id='cardNum']
    Click Element    //input[@id='cardNum']
    Input Text    //input[@id='cardNum']    ${card_number}
    Click Element    //input[@id='fullName']
    Input Text    //input[@id='fullName']    ${card_holder}
    Select From List By Label    //select[@title='Month']    ${card_expire_month}
    Select From List By Label    //select[@title='Year']    ${card_expire_year}
    Click Element    //input[@id='cvc']
    Input Text    //input[@id='cvc']    ${card_cvc}
    Click Button    //button[@id='confirm']
    
A confirmation of the booking is shown    
    [Documentation]    Successful Booking - A confirmation of the booking is shown
    [Tags]    VG_test    booking    successful-booking
    [Arguments]    ${car_model}    ${pickup_date}

    Wait Until Page Contains    A ${car_model} is now ready for pickup ${pickup_date}
    
User logs in with invalid credentials
    [Documentation]    Header - User tries to login in with invalid credentials
    [Tags]    VG_test    header    login
    [Arguments]    ${user_email}    ${user_password}

    Input Text    //input[@id='email']    ${invalid_user_email}
    Input Password    //input[@id='password']    ${invalid_user_password}
    Click Button    //button[@id='login']

An error message appears to the left of the buttons
    [Documentation]    Header - Checks for error text: 'If the user inserts the wrong information a error message appears to the left of the buttons.'
    [Tags]    VG_test    header    login

    Wait Until Element Contains    //label[@id='signInError']    Wrong e-mail or password

An error message appears on the page
    [Documentation]    Car Selection - If the user isn't signed in an error message appears on the page
    [Tags]    VG_test    booking    car-selection

    Alert Should Be Present    You need to be logged in to continue.

User cancels booking on 'My page'
    [Documentation]    My Page - User completes booking and goes to 'My page' and clicks 'Cancel booking' for the same booking
    [Tags]    VG_test    cancellation    my-page
    [Arguments]    ${license_number}

    Click Button    //button[@id='mypage']
    Wait Until Element Is Visible    xpath=//input[@value='${license_number}']/../button[text()='Cancel booking']
    Click Button    xpath=//input[@value='${license_number}']/../button[text()='Cancel booking']
    Handle Alert

A confirmation of the cancellation is shown
    [Documentation]    My Page - User completes booking and goes to 'My page' and clicks 'Cancel booking' for the same booking
    [Tags]    VG_test    cancellation    my-page
    [Arguments]    ${license_number}

    Wait Until Page Contains    Your car: ${license_number} has been Returned

User filters cars by seating capacity
    [Documentation]    Car Selection - saves license plates for cars with seating capacity = ${car_seating_capacity} and then filters cars
    [Tags]    VG_test    booking    car-selection
    [Arguments]    ${car_seating_capacity}

    ${plate_elements}=    Get Webelements    xpath=//input[contains(@id, 'pass${car_seating_capacity}')]/../input[@name='licenseNumber']

    FOR    ${element}    IN    @{plate_elements}
        ${license_number}=    Get Element Attribute    ${element}    value
        Append To List    ${expected_license_numbers}    ${license_number}
        #Log To Console    ${plate}
    END

    Wait Until Element Is Visible    //div[@id='ms-list-2']//button[@type='button']
    Click Button    //div[@id='ms-list-2']//button[@type='button']
    Click Element   css=[data-search-term='${car_seating_capacity}']
    Click Button    //div[@id='ms-list-2']//button[@type='button']

All available cars with selected seating capacity is shown
    [Documentation]    Car Selection - Compares expected cars with seating capacity = ${car_seating_capacity} to filtered
    [Tags]    VG_test    booking    car-selection
    [Arguments]    ${expected_license_numbers}

    Wait Until Page Contains Element    //div[@id='carSelection']
    ${plate_elements}=    Get Webelements    xpath=//input[@name='licenseNumber']

    FOR    ${plate}    IN    @{plate_elements}
        ${license_number}=    Get Element Attribute    ${plate}    value
        Append To List    ${actual_license_numbers}    ${license_number}
        Log    ${license_number}
    END

    Lists Should Be Equal    ${actual_license_numbers}    ${expected_license_numbers}

A book button is shown next to all available cars
    [Documentation]    Car Selection - if a book button is visible for all filtered cars
    [Tags]    VG_test    booking    car-selection

    ${carRow_elements}=    Get Webelements    css:.carRow
    ${carRow_count}=    Get Length     ${carRow_elements}

    ${status}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@value='book']    ${carRow_count}
    
    IF    ${status}
        Log    The page's got the expected amount of elements with xpath=//input[@value='book']
    ELSE
        ${book_elements}=    Get Webelements    xpath=//input[@value='book']
        ${book_elements_count}=    Get Length     ${book_elements}
        Fail    Found ${book_elements_count} elements with xpath=//input[@value='book'] instead of ${carRow_count}
    END

Close test environment
    [Documentation]    Close Browser

    Close Browser
