Story: Managing Band-member Information
	As a band member, I want a way to edit my own profile, so that I can change my biography, picture, and contact information.
	As a board member or a webmaster, I want a way to edit any member's profile, to change the normal stuff plus his status (active, on leave, etc.) in the band.
	
	#
	# Changing personal information
	#
	
	Scenario: As a regular member, I log in and change my picture.
		Given an anonymous member
		  And a registered member named 'Reggie Funkle'
		  And we memorize Reggie Funkle's biography, email, and photo_file_name
		
		 When the anonymous member logs in with name: 'Reggie Funkle', and password: '1234reggie'
		 Then he should be redirected to Reggie Funkle's home page
		  And he should see a link labeled Edit
		
		 When he clicks "Edit"
		 Then he should be taken to the edit member Reggie Funkle page
		  And he should see a <form> containing a file: Photo
		
		 When he attaches the file at "features/support/new_picture.jpg" to "Photo"
		  And he presses "Save"
		 Then he should be redirected to Reggie Funkle's home page
		  And Reggie Funkle's photo_file_name should change
		  And Reggie Funkle's biography should not change
		  And Reggie Funkle's email should not change
		
	Scenario: As a regular member, I log in and change my e-mail address.
		Given an anonymous member
		  And a registered member named 'Reggie Funkle'
		  And we memorize Reggie Funkle's biography, email, and photo_file_name
		
		 When the anonymous member logs in with name: 'Reggie Funkle', and password: '1234reggie'
		 Then he should be redirected to Reggie Funkle's home page
		  And he should see a link labeled Edit
		
		 When he clicks "Edit"
		 Then he should be taken to the edit member Reggie Funkle page
		  And he should see a <form> containing a textfield: E-Mail
		
		 When he fills in "E-Mail" with "new_email@somewhere.gov"
		  And he presses "Save"
		 Then he should be redirected to Reggie Funkle's home page
		  And Reggie Funkle's email should change
		  And Reggie Funkle's photo_file_name should not change
		  And Reggie Funkle's biography should not change
		
	Scenario: As a regular member, I log in and change my e-mail address.
		Given an anonymous member
		  And a registered member named 'Reggie Funkle'
		  And we memorize Reggie Funkle's biography, email, and photo_file_name

		 When the anonymous member logs in with name: 'Reggie Funkle', and password: '1234reggie'
		 Then he should be redirected to Reggie Funkle's home page
		  And he should see a link labeled Edit

		 When he clicks "Edit"
		 Then he should be taken to the edit member Reggie Funkle page
		  And he should see a <form> containing a textfield: Biography

		 When he fills in "Biography" with "I was a happy child once."
		  And he presses "Save"
		 Then he should be redirected to Reggie Funkle's home page
		  And Reggie Funkle's biography should change
		  And Reggie Funkle's email should not change
		  And Reggie Funkle's photo_file_name should not change
	
	Scenario: As a regular member, I can log in and go to someone else's private member page.
		Given a regular member logged in as 'Reggie Funkle'
		  And a registered member named 'Oona Funkle'
		 When Reggie goes to Oona Funkle's home page
		 Then she should be redirected to Oona Funkle's home page
		  And she should not see an error message 'You do not have permission'
			And she should not see a link labeled Edit
		
	Scenario: As a regular member, I cannot log in and edit someone else's information.
		Given a regular member logged in as 'Reggie Funkle'
		  And a registered member named 'Oona Funkle'
		 When Reggie goes to edit member Oona Funkle
		 Then she should be redirected to the private member list page
		  And she should see an error message 'You do not have permission'
		