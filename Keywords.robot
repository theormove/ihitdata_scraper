*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN URL}    ${BROWSER}

Input Username
    [Arguments]    ${username}
    Input Text    id:email    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    id:password    ${password}

Submit Credentials
    Click Button    id:submit

Login
	[Arguments]	${email}	${password}
    Input Username    ${email}  
    Input Password    ${password}    
    Submit Credentials



Scrape First Companies
	[Arguments]	${number_of_companies}
	@{companies_links_aihit}=	Create List
	FOR    ${i}    IN RANGE    ${number_of_companies}
		${company_xpath_aihit_part_start}=    Set Variable    //html/body/div[2]/div[2]/div[2]/div/div/div[
		${company_xpath_aihit_part_end}=    Set Variable    ]/div/div[1]/a
		${company_xpath_aihit}=    Set Variable    ${company_xpath_aihit_part_start}${i+1}${company_xpath_aihit_part_end}
		${company_link_aihit}=	Get Element Attribute	${company_xpath_aihit}	href
		Append To List    ${companies_links_aihit}	${company_link_aihit}
	END
	${companies_data}=	Create Dictionary
	${company_id}=	Set Variable    0	
	FOR    ${company_link_aihit}    IN    @{companies_links_aihit}
		${company_data}=	Create Dictionary
		Go To    ${company_link_aihit}
		${phone}=	Set Variable    None
		${phone}=	Get Company Field    //html/body/div[2]/div[1]/div[2]/div[1]/div/div[1]/div[1]/ul[2]/li[3]    
		${name}=    Get Company Field	//html/body/div[2]/div[1]/div[2]/div[1]/div/div[1]/div[1]/h1
		${address}=    Get Company Field    //html/body/div[2]/div[1]/div[2]/div[1]/div/div[1]/div[1]/div[2]
		${email}=    Get Company Field	//html/body/div[2]/div[1]/div[2]/div[1]/div/div[1]/div[1]/ul[2]/li[2]/a
		${website}=    Get Company Field	//html/body/div[2]/div[1]/div[2]/div[1]/div/div[1]/div[1]/ul[2]/li[1]/a/span
		Set To Dictionary	${company_data}    name=${name}	email=${email}	website=${website}	address=${address}	phone=${phone}
		${company_id}=	Convert To Integer	${company_id}
		${company_id}=	Evaluate    ${company_id}+1
		${company_id}=	Convert To String	${company_id}
		Set To Dictionary	${companies_data}	${company_id}=${company_data} 		
		Log To Console    ${name}   
    END
    ${companies_data}=	Convert JSON To String	${companies_data} 
    Create File  ${EXECDIR}/companies_data.json  ${companies_data}

Get Company Field
	[Arguments]	${xpath}
	${possible_value}=	Run Keyword And Ignore Error	Get Text	${xpath}
	${possible_value_type}=	Evaluate	type(${possible_value})
	${possible_value_list}=	Convert To List    ${possible_value}
	${is_found}=	Get From List    ${possible_value_list}	0
	${value}=	Get From List    ${possible_value_list}	1	
	Run Keyword If    '${is_found}'=='PASS'    Return From Keyword    ${value}   
    Return From Keyword    None