*** Settings ***
Documentation    Resources for Infotiv car rental site tests
Library    SeleniumLibrary

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

*** Keywords ***
Setup test environment
    [Documentation]    Open rental site with Chrome and log in on existing user account

    Open Browser    ${rental_site_url}    ${browser}
    Maximize Browser Window
    Wait Until Element Is Visible    //input[@id='email']
    Input Text    //input[@id='email']    ${user_email}
    Input Password    //input[@id='password']    ${user_password}
    Click Button    //button[@id='login']

User is logged in and on date selection page
    [Documentation]    Check if user is logged in and on date selection page
    [Tags]    VG_test
    
    Wait Until Page Contains    You are signed in as ${user_first_name}
    Wait Until Element Is Visible    //input[@id='start']

User selects rental period and car
    [Documentation]    Fill in data needed to rent a car (5-seat Audi TT)
    [Tags]    VG_test    user-input    navigation    booking
    [Arguments]    ${start_date}    ${end_date}    ${car_id}

    Click Element    //input[@id='start']
    Input Text    //input[@id='start']    text=${start_date}
    Click Element    //input[@id='end']
    Input Text    //input[@id='end']    text=${end_date}
    Click Button    //button[@id='continue']

    Wait Until Element Is Visible    //input[@id='${car_id}']
    Click Element    //input[@id='${car_id}']

User submits credit card info
    [Documentation]    Fill in credit card info and click 'Confirm'
    [Tags]    VG_test    user-input    navigation    booking

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
    [Documentation]    A confirmation of the booking is shown
    [Tags]    VG_test    booking

    Wait Until Page Contains    A ${car_model} is now ready for pickup ${pickup_date}

Close test environment
    [Documentation]    Close Browser

    Close Browser
