$(function() {
	roster_effects_setup();
});

function roster_effects_setup() {
	prepare_updown_buttons();
};

/*
 * If users prefer to click, allow up/down buttons to work with AJAX.
 */
function prepare_updown_buttons() {
	// Stylize the up/down buttons.
	$('.member-up-button'  ).button({ icons: {primary: 'ui-icon-arrowthickstop-1-n'}, text: false });
	$('.member-down-button').button({ icons: {primary: 'ui-icon-arrowthickstop-1-s'}, text: false });
	$('li.member:first-child .member-up-button'  ).button("disable");
	$('li.member:last-child  .member-down-button').button("disable");
	
	// Link the up/down buttons with an AJAX recall.
	run_button_action = function() {
		$.ajax({
			data: $(this).serialize(),
			type: 'put',
			url: $(this).find('a').attr('href') + '.js',
			dataType: 'script',    // Evaluate the rjs result.
			success: roster_effects_setup
		});
	};
	
	$('.member-up-button, .member-down-button').click(run_button_action);
}
