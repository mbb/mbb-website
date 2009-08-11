Story:
	As a casual visitor or family member of the band,
	I want to see all concerts in a tabular form
	So that it's easy to print it out and keep up with the group.
	
	Scenario: Casual visitor goes to the upcoming concerts list to see what's coming up.
		Given an anonymous user
		  And an upcoming concert 
		 When she goes to the upcoming concerts page
		 Then she should see the upcoming concert