Story:
	As a visitor to the site,
	I want to see all the basic informations about the band
	So that I know how to attend a concert, join the band, or book the band.
	
	Scenario: A visitor finds out the title and date of our next concert.
		Given an upcoming concert
		  And an anonymous visitor
		 When he goes to the home page
		 Then he should see the concert title
		  And he should see the concert date
		  And he should see a link labeled Our Next Concert
		 When he clicks "Our Next Concert"
		 Then he should be taken to the next concert page
	
	Scenario: A visitor finds out that we have no concerts scheduled.
		Given no upcoming concerts
		  And an anonymous visitor
		 When he goes to the home page
		 Then he should see "No Upcoming Concerts"
		  And he should see a link labeled Book Us for a Performance
		 When he clicks "Book Us for a Performance"
		 Then he should be taken to the booking page
	