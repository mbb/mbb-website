Members want to know that nobody can masquerade as them.  We want to extend trust
only to visitors who present the appropriate credentials.  Everyone wants this
identity verification to be as secure and convenient as possible.

Story: Logging in
  As an anonymous member with an account, I want to log in to my account so that I can access private data.
  
  #
  # Good logins are successful!
  #

	Scenario: Anonymous member can get a login form.
    Given  an anonymous member
     When  she goes to /login
     Then  she should be at the new sessions page
      And  she should see a <form> containing a textfield: E-Mail, password: Password, and submit: 'Log in'

  Scenario: Anonymous member can log in and be remembered
    Given  an anonymous member
      And  an activated member named 'Reggie Funkle'
     When  she logs in with email: 'registered@example.com', password: '1234reggie'
     Then  she should be redirected to Reggie Funkle's home page
      And  she should see a notice message 'Logged in successfully'
      And  Reggie Funkle should be logged in
		 When  she goes to Reggie Funkle's home page again
		 Then  she should be at ReggieFunkle's home page
		  And  Reggie Funkle should be logged in
		  And  she should not see a notice message 'Logged in successfully'
   
  #
  # Bad logins are rejected!
  #
  
  Scenario: Logged-in member who fails logs in should be logged out
    Given an activated member named 'Oona Funkle'
    When  she logs in with email: 'unactivated@example.com', password: '1234oona'
    Then  she should be redirected to Oona Funkle's home page
    Then  she should see a notice message 'Logged in successfully'
     And  Oona Funkle should be logged in
    When  she logs in with email: 'registered@example.com', password: 'i_haxxor_joo'
    Then  she should be at the new sessions page
    Then  she should see an error message 'Couldn't log you in as 'registered@example.com''
     And  Oona Funkle should not be logged in
  
  Scenario: Log-in with bogus info should fail until it doesn't
    Given an activated member named 'Reggie Funkle'
		  And no member with name: 'leonard_shelby' exists
    When  she logs in with email: 'registered@example.com', password: 'i_haxxor_joo'
    Then  she should be at the new sessions page
    Then  she should see an error message 'Couldn't log you in as 'registered@example.com''
     And  Reggie Funkle should not be logged in
    When  she logs in with email: 'registered@example.com', password: ''
    Then  she should be at the new sessions page
    Then  she should see an error message 'Couldn't log you in as 'registered@example.com''
     And  Reggie Funkle should not be logged in
    When  she logs in with email: '', password: 'monkey'
    Then  she should be at the new sessions page
    Then  she should see an error message 'Couldn't log you in as '''
     And  she should not be logged in
    When  she logs in with email: 'leonard_shelby', password: 'monkey'
    Then  she should be at the new sessions page
    Then  she should see an error message 'Couldn't log you in as 'leonard_shelby''
     And  Leonard Shelby should not be logged in
    When  she logs in with email: 'registered@example.com', password: '1234reggie'
    Then  she should be redirected to Reggie Funkle's home page
    Then  she should see a notice message 'Logged in successfully'
     And  Reggie Funkle should be logged in


  #
  # Logging out always works!
  #

  Scenario: Anonymous (logged out) member can log out.
    Given an anonymous member
    When  she goes to /logout
    Then  she should be redirected to the home page
    Then  she should see a notice message 'You have been logged out'
     And  she should not be logged in

  Scenario: Logged in member can log out.
    Given an activated member logged in as 'Reggie Funkle'
    When  she goes to /logout
    Then  she should be redirected to the home page
    Then  she should see a notice message 'You have been logged out'
     And  she should not be logged in
