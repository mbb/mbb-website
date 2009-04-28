Story: Creating Accounts for Band Members
	As a board member, I want to be able to create accounts for band members so that they are listed on the members page.

	Scenario: Board member can create an account
		Given a board member logged in as 'Reggie Funkle'
		  And no member with name: 'Oona Funkle' exists
		 When Reggie registers an account for the preloaded 'Oona Funkle'
		 Then Reggie should be redirected to the private member list page
		  And Reggie should see a notice message 'Oona Funkle has been added to the band!'
		  And a member with name: 'Oona Funkle' should exist
		  And Reggie should see "Oona Funkle"
		  And the member should have name: 'Oona Funkle', and email: 'unactivated@example.com'
		  And Reggie Funkle should be logged in

	Scenario: Board member can not create an account replacing an activated account
		Given a board member logged in as 'Oona Funkle'
		  And an activated member named 'Reggie Funkle'
		  And we try hard to remember the member's created_at
		 When Reggie registers an account with name: 'Reggie Funkle', email: 'reggie@example.com', and section: 'Euphonium'
		 Then Reggie should be redirected to the create-new-member page
		  And Reggie should see an errorExplanation message 'Reggie Funkle is already in the band!'
		  And Reggie should not see an errorExplanation message 'Someone already owns the e-mail address reggie@example.com.'
		  And a member with name: 'Reggie Funkle' should exist
		  And the member should have email: 'registered@example.com'
		  And the member's created_at should stay the same under to_s

	Scenario: Board member can not create an account with incomplete or incorrect input
		Given a board member logged in as 'Reggie Funkle'
		  And no member with name: 'Oona Funkle' exists
		 When the board member registers an account with name: '', email: 'unactivated@example.com', and section: 'Trombone'
		 Then the board member should be at the create-new-member page
		  And the board member should see an errorExplanation message 'Name can't be blank'
		  And no member with name: '' should exist

	Scenario: Board member can not create an account with bad email
		Given a board member logged in as 'Reggie Funkle'
		  And no member with name: 'Oona Funkle' exists
		 When he registers an account with name: 'Oona Funkle', email: '', and section: 'Cornet'
		 Then he should be at the create-new-member page
		  And he should see an errorExplanation message 'Email can't be blank'
		  And no member with name: 'Oona Funkle' should exist
		
	Scenario: Board member can create an account with all the necessary attributes.
		Given a board member logged in as 'Reggie Funkle'
		 When Reggie registers an account with name: 'Oona Funkle', section: 'Soprano Cornet', and email: 'unactivated@example.com'
		 Then she should be redirected to the private member list page
		 Then she should see a notice message 'Oona Funkle has been added to the band!'
		  And a member with name: 'Oona Funkle' should exist
		  And the member should have name: 'Oona Funkle', and email: 'unactivated@example.com'
		  And Reggie Funkle should be logged in
		  And Oona Funkle should have the default password
		 When Reggie goes to the private member list page
		 Then I should see Oona Funkle in the Soprano Cornet section

