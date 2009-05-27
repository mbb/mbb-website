Story:
	As a board member or web administrator
	I want obvious and exclusive access to creating and destroying new members
	So that the band roster maintains its integrity.
	
	Scenario: A Board Member logs in and creates a new member.
		Given a board member logged in as 'Reggie Funkle'
		 When Reggie goes to the private member list page
		 Then she should see a link labeled Add a New Member
		 When she clicks "Add a New Member"
		 Then she should be taken to the create-new-member page
		 When she registers an account for the preloaded 'Oona Funkle'
		 Then she should be taken to the private member list page
		  And she should see a notice message 'Oona Funkle has been added to the band!'
	
	Scenario: A non-board member logs in and does NOT see a link to create a new member.
		Given a regular member logged in as 'Oona Funkle'
		  And a board member named 'Reggie Funkle'
		 When Oona goes to the private member list page
		 Then she should not see a link labeled Add a New Member
		  And she should not see a link labeled Remove from Band
	
