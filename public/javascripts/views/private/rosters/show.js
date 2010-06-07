$(function() {
	roster_effects_setup();
});

function roster_effects_setup() {
	prepare_draggable_members();
	prepare_updown_buttons();
};


/*
 * Members should be sortable within sections and between sections.
 */
function prepare_draggable_members() {
	// The user interface should support this by dragging and dropping.
	$('.section').sortable({
		connectWith: '.section',
		cursor: "move",
		forceHelperSize: true,
		opacity: 0.6,
		stop: refresh_updown_buttons  // Fix the buttons, which must surely have changed.
	});
	
	// Show a hint to the user.
	// Dragging is javascript-only functionality, else this would be fine in CSS.
	$('.hint').addClass("instructions");
	$('.member').mouseenter(function() { $(this).find('.hint').css('visibility', 'visible'); });
	$('.member').mouseleave(function() { $(this).find('.hint').css('visibility', 'hidden' ); });
}


function refresh_updown_buttons() {
	$('li.member:first-child .member-up-button'  ).button("disable");
	$('li.member:last-child  .member-down-button').button("disable");
	$('li.member:not(li.member:first-child) .member-up-button'  ).button("enable");
	$('li.member:not(li.member:last-child)  .member-down-button').button("enable");
}


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
