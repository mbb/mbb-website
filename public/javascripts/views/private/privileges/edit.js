/*
 * Written as an onChange handler.
 */
function submit_member_privilege_change() {
	$.ajax({
		type: 'put',
		url: $(this).parent('form').attr('action') + '.json',
		data: $(this).parent('form').serialize()
	});
}

$(function() {
	$('.member_privileged_checkbox').change(submit_member_privilege_change);
});
