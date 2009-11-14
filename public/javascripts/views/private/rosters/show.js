//
// For every row in the roster, set the <select> menu (for the user's section) to
// automatically submit a form which moves the user visually to the new section.
// The result from the server is expected to return an eval()'able code which
// will move the items.
//
function activate_form_submit_on_section_change(affected_forms)	{
	// Generate an AJAX call when the section-changing form is submitted
	affected_forms.submit(function()	{
		console.debug($(this).attr('action') + '.json');
		$.ajax({
			data: $(this).serialize(),
			type: 'post',
			url: $(this).attr('action') + '.js',
			dataType: 'script'    // Evaluate the rjs result.
		});

		// Do not send the actual form; that will cause a page refresh.
		return false;
	});
	
	// Trigger the ajax callback whenever the <select>s are changed.
	affected_forms.find(' > select').change(function() {
		$(this).parent().submit();
	});
}

$(document).ready(function() {
	// Set up all of the section-changing forms per the above.
	var section_selecting_forms = $('form.member_section_selector');
	activate_form_submit_on_section_change(section_selecting_forms);
});