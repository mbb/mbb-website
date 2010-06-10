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
	update_member = function(event, ui) {
		if (update_member[ui.item] != undefined)
			var old_section = update_member[ui.item].sender;
		
		var new_section = ui.item.parent();
		var new_section_id = new_section.attr('id').match(/section_(\d+)$/)[1];
		
		var next_member = ui.item.next('.member');
		if (next_member.length == 0)
			var new_position = null;
		else
			var new_position = next_member.attr('id').match(/member_(\d+)$/)[1];
		
		$.ajax({
			type: 'put',
			url: ui.item.find('> a').attr('href') + '.json',
			data: {
				member: {
					section_id: new_section_id,
					position: new_position
				}
			},
			dataType: 'json',
			complete: function(_, status) {
				refresh_updown_buttons();
				if (old_section != undefined)
					enable_dragging(old_section);
				
				enable_dragging(new_section);
			}
		});
	};
	
	disable_dragging = function(where, message) {
		where.sortable("disable");
		where.parent().block({
			message: message
		});
	};
	
	enable_dragging = function(where) {
		where.sortable("enable")
		where.parent().unblock();
	};
	
	stop_handler = function(event, ui) {
		disable_dragging($(event.srcElement).parent(), 'Moving ' + ui.item.find('.name')[0].innerHTML);
		update_member(event, ui);
	};
	
	receive_handler = function(event, ui) {
		update_member[ui.item] = {sender: ui.sender};
		disable_dragging(ui.sender, 'Moving ' + ui.item.find('.name')[0].innerHTML);
	};
	
	// The user interface should support this by dragging and dropping.
	$('.section').sortable({
		connectWith: '.section',
		cursor: "move",
		forceHelperSize: true,
		opacity: 0.6,
		stop: stop_handler,
		receive: receive_handler
	});
	
	// Show a hint to the user.
	// Dragging is javascript-only functionality, else this would be fine in CSS.
	$('.hint').addClass("instructions");
	$('.member').mouseenter(function() { $(this).find('.hint').css('visibility', 'visible'); });
	$('.member').mouseleave(function() { $(this).find('.hint').css('visibility', 'hidden' ); });
}


/*
 * In case the buttons no longer match their surroundings (e.g. after drag+drop), refresh them
 * based on the presence of immediate neighbors.
 */
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
