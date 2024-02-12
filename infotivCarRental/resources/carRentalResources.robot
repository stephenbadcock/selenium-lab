*** Settings ***
Documentation    Resources for Infotiv car rental site tests
Library    SeleniumLibrary

*** Variables ***
${rental_site_url}    https://rental4.infotiv.net/
${browser}    Chrome
${user_email}    kungen@slottet.se
${user_password}    123456
${user_first_name}    Carl

*** Keywords ***
Setup Test Environment
    [Documentation]    Open rental site with Chrome and log in on existing user account

    Open Browser    ${rental_site_url}    ${browser}
    Maximize Browser Window
    Input Text    //input[@id='email']    ${user_email}
    Input Password    //input[@id='password']    ${user_password}
    Click Button    //button[@id='login']

