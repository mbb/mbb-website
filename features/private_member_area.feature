Story: Band Members have a Private Section
	As a member of the band, I want a section of the page that I can only access when logged in, so I can read private information.

	Scenario: Anonymous members cannot access the private area through any direct link.
		Given  an anonymous member
		  And  an activated member named 'Reggie Funkle'
		
		 When	 she goes to the create-new-member page
		 Then	 she should be redirected to the login page
		  And  she should see an error message 'You must be a member to access this page. Please log in.'
		
		 When  she goes to the private member list page
		 Then  she should be redirected to the login page
		  And  she should see an error message 'You must be a member to access this page. Please log in.'
		