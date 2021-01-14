*** Settings ***
Documentation     Scrapes mortgage companies from ihitdata.com.
Library           SeleniumLibrary	run_on_failure=Nothing
Library    Collections
Library    OperatingSystem
Library    JSONLibrary
Resource	Keywords.robot
Resource	Variables.robot



*** Tasks ***
Login To The Website
	Open Browser To Login Page 
	Login    ${EMAIL}    ${PASSWORD}
Search For Mortgage Companies Located In US
    Input Text    id:industry    mortgage
    Input Text    id:location    US
    Click Button   xpath:/html/body/div[2]/div/div[2]/div/div/form/button
Scrape First 30 Companies
	Scrape First companies    30



