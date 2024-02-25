*** Settings ***
Documentation    Resources for tests of Infotiv car rental site https://rental4.infotiv.net/
Library    SeleniumLibrary
Library    Collections
Library    DateTime

*** Variables ***
# Setup data
${selenium_speed}    1
${homepage_url}    https://rental4.infotiv.net/
${browser}    Chrome

# Valid user data
${valid_user_email}    kungen@slottet.se
${valid_user_password}    123456
${user_first_name}    Carl
${card_number}    1234123412341234
${card_holder}    Carl XVI Gustaf Folke Hubertus Bernadotte
${card_expire_month}    11
${card_expire_year}    2025
${card_cvc}    888

# Invalid user data
${invalid_user_email}    drottningen@slottet.se
${invalid_user_password}    abcdef

# Booking data
${days_until_pickup}    1
${days_until_return}    8
${pickup_date}
${car_model}    Audi TT
${license_number}    DHW439
${license_number2}    CEA328

# Filter data
@{two_car_makes}    Audi    Opel
@{two_car_seating_capacities}    2    9
@{zero_car_makes}
@{zero_car_seating_capacities}
@{expected_license_numbers_makes}
@{expected_license_numbers_passengers}

*** Keywords ***
Setup test environment
    [Documentation]    Sets Selenium speed, opens ${browser} and maximizes browser window

    Set Selenium Speed    ${selenium_speed}
    Open Browser    browser=${browser}
    Maximize Browser Window

Initialize Test
    [Documentation]    Start all test cases from ${homepage_url}

    Go To    ${homepage_url}

User is on date selection page
    [Documentation]    Date selection - Checks if user is on date selection page
    [Tags]    VG_test    date-selection

    Wait Until Element Contains    //h1[@id='questionText']    When do you want to make your trip?

User logs in with valid credentials
    [Documentation]    Header - User logs in with valid credentials
    [Tags]    VG_test    header    login
    [Arguments]    ${user_email}    ${user_password}    ${user_first_name}

    Wait Until Element Is Visible    //input[@id='email']
    Wait Until Element Is Visible    //input[@id='password']
    Wait Until Element Is Visible    //button[@id='login']

    Input Text    //input[@id='email']    ${user_email}
    Input Password    //input[@id='password']    ${user_password}

    Click Button    //button[@id='login']

    Wait Until Page Contains    You are signed in as ${user_first_name}
    
User selects rental period
    [Documentation]    Date selection - selects rent period based on days from current date
    [Tags]    VG_test    date-selection    booking
    [Arguments]    ${days_until_pickup}    ${days_until_return}

    ${pickup_date}=    Get Current Date    increment=${days_until_pickup} days    result_format=%Y-%m-%d
    ${start_date_MMDD}=    Convert Date    ${pickup_date}    result_format=%m%d
    ${end_date_MMDD}=    Get Current Date    increment=${days_until_return} days    result_format=%m%d

    Wait Until Element Is Visible    //input[@id='start']
    Wait Until Element Is Visible    //input[@id='end']
    Wait Until Element Is Visible    //button[@id='continue']

    Click Element    //input[@id='start']
    Input Text    //input[@id='start']    ${start_date_MMDD}

    Click Element    //input[@id='end']
    Input Text    //input[@id='end']    ${end_date_MMDD}

    Click Button    //button[@id='continue']

User selects car
    [Documentation]    Car Selection - Chooses car with license number ${license_number}
    [Tags]    VG_test    car-selection    booking
    [Arguments]    ${license_number}

    Wait Until Element Is Visible    //input[@value='${license_number}']/../input[@value='Book']
    Click Element    //input[@value='${license_number}']/../input[@value='Book']

User submits credit card info
    [Documentation]    Confirm Booking - Fills in credit card info and clicks 'Confirm'
    [Tags]    VG_test    confirm-booking    booking
    [Arguments]    ${card_number}    ${card_holder}    ${card_expire_month}    ${card_expire_year}    ${card_cvc}

    Wait Until Element Is Visible    //input[@id='cardNum']
    Wait Until Element Is Visible    //input[@id='fullName']
    Wait Until Element Is Visible    //select[@title='Month']
    Wait Until Element Is Visible    //select[@title='Year']
    Wait Until Element Is Visible    //input[@id='cvc']
    Wait Until Element Is Visible    //button[@id='confirm']

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
    [Tags]    VG_test    successful-booking    booking
    [Arguments]    ${car_model}    ${pickup_date}

    Wait Until Element Is Visible    //button[@id='logout']
    Wait Until Page Contains    A ${car_model} is now ready for pickup ${pickup_date}

    Click Button    //button[@id='logout']
    
User tries to log in with invalid credentials
    [Documentation]    Header - User tries to log in in with invalid credentials
    [Tags]    header    login
    [Arguments]    ${user_email}    ${user_password}

    Wait Until Element Is Visible    //input[@id='email']
    Wait Until Element Is Visible    //input[@id='password']
    Wait Until Element Is Visible    //button[@id='login']

    Input Text    //input[@id='email']    ${user_email}
    Input Password    //input[@id='password']    ${user_password}
    
    Click Button    //button[@id='login']

An error message appears to the left of the buttons
    [Documentation]    Header - Checks for error message to the left of the buttons
    [Tags]    header    login

    Wait Until Element Contains    //label[@id='signInError']    Wrong e-mail or password

An error message appears on the page
    [Documentation]    Car Selection - If the user isn't signed in an alert box with an error message appears on the page
    [Tags]    car-selection    booking

    Alert Should Be Present    You need to be logged in to continue.

User cancels booking on 'My page'
    [Documentation]    My Page - User goes to 'My page' and clicks 'Cancel booking' for the recently booked car
    [Tags]    my-page    cancellation
    [Arguments]    ${license_number}

    Wait Until Element Is Visible    //button[@id='mypage']
    Click Button    //button[@id='mypage']
    
    Wait Until Element Is Visible    xpath=//input[@value='${license_number}']/../button[text()='Cancel booking']
    Click Button    xpath=//input[@value='${license_number}']/../button[text()='Cancel booking']
    Handle Alert

A confirmation of the cancellation is shown
    [Documentation]    My Page - A confirmation of the cancellation is shown on the page
    [Tags]    my-page    cancellation
    [Arguments]    ${license_number}

    Wait Until Element Is Visible    //button[@id='logout']
    Wait Until Page Contains    Your car: ${license_number} has been Returned

    Click Button    //button[@id='logout']

User filters cars by selected criteria
    [Documentation]    Car Selection - saves license numbers for cars with selected makes and seating capacities, then filters cars
    [Tags]    car-selection    filtering
    [Arguments]    ${car_makes}    ${car_seating_capacities}

    FOR    ${make}    IN     @{car_makes}
        ${make_elements}=    Get Webelements    xpath=//input[@value='${make}']/../input[@name='licenseNumber']

        FOR    ${plate}    IN    @{make_elements}
            ${license_number}=    Get Element Attribute    ${plate}    value
            Append To List    ${expected_license_numbers_makes}    ${license_number}
            Log    ${expected_license_numbers_makes}
        END
    END

    FOR    ${capacity}    IN     @{car_seating_capacities}
        ${capacity_elements}=    Get Webelements    xpath=//input[contains(@id, 'pass${capacity}')]/../input[@name='licenseNumber']

        FOR    ${plate}    IN    @{capacity_elements}
            ${license_number}=    Get Element Attribute    ${plate}    value
            Append To List    ${expected_license_numbers_passengers}    ${license_number}
            Log    ${expected_license_numbers_passengers}
        END
    END

    Wait Until Element Is Visible    //div[@id='ms-list-1']//button
    Wait Until Element Is Visible    //div[@id='ms-list-2']//button

    Click Button    //div[@id='ms-list-1']//button

    FOR    ${make}    IN     @{car_makes}
        Click Element   css=[data-search-term='${make.lower()}']
    END

    Click Button    //div[@id='ms-list-2']//button

    FOR    ${capacity}    IN     @{car_seating_capacities}
        Click Element   css=[data-search-term='${capacity}']
    END

    Click Button    //div[@id='ms-list-2']//button

All available cars filtered by one criterion are shown
    [Documentation]    Car Selection - Compares expected cars with selected criterion to filtered
    [Tags]    car-selection    filtering
    [Arguments]    @{expected_license_numbers_makes}

    Wait Until Page Contains Element    //div[@id='carSelection']

    ${plate_elements}=    Get Webelements    xpath=//input[@name='licenseNumber']
    ${actual_license_numbers}=    Create List

    FOR    ${plate}    IN    @{plate_elements}
        ${license_number}=    Get Element Attribute    ${plate}    value
        Append To List    ${actual_license_numbers}    ${license_number}
    END

    Lists Should Be Equal    ${actual_license_numbers}    ${expected_license_numbers_makes}
    
All available cars filtered by two criteria are shown
    [Documentation]    Car Selection - Compares expected cars with selected criteria to filtered
    [Tags]    car-selection    filtering
    [Arguments]    ${expected_license_numbers_makes}    ${expected_license_numbers_passengers}

    ${expected_license_numbers}=    Create List

    FOR    ${license_number}    IN    @{expected_license_numbers_makes}
        Run Keyword If    '${license_number}' in @{expected_license_numbers_passengers}    Append To List    ${expected_license_numbers}    ${license_number}
    END

    Wait Until Page Contains Element    //div[@id='carSelection']

    ${plate_elements}=    Get Webelements    xpath=//input[@name='licenseNumber']
    ${actual_license_numbers}=    Create List

    FOR    ${plate}    IN    @{plate_elements}
        ${license_number}=    Get Element Attribute    ${plate}    value
        Append To List    ${actual_license_numbers}    ${license_number}
    END

    ${status}=    Run Keyword And Return Status    Lists Should Be Equal    ${actual_license_numbers}    ${expected_license_numbers}

    IF    ${status}
        Log    Filtered list displayed the expected cars: @{expected_license_numbers}
    ELSE
        Fail    The actual cars displayed @{actual_license_numbers} weren't the same as expected @{expected_license_numbers}
    END    

There should be a book button next to all available cars
    [Documentation]    Car Selection - Checks if there's a book button next to all filtered cars
    [Tags]    car-selection    filtering

    ${carRow_elements}=    Get Webelements    css:.carRow
    ${expected_book_elements}=    Get Length     ${carRow_elements}

    ${status}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@value='book']    ${expected_book_elements}

    IF    ${status}
        Log    The page's got the expected amount of elements with xpath=//input[@value='book']
    ELSE
        ${book_elements}=    Get Webelements    xpath=//input[@value='book']
        ${actual_book_elements}=    Get Length    ${book_elements}

        Fail    Found ${actual_book_elements} elements with xpath=//input[@value='book'] instead of ${expected_book_elements}
    END

Close test environment
    [Documentation]    Closes Browser

    Close Browser
