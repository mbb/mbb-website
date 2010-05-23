/*!
 * Assumed as the onchange handler for the drop-down menu to select a member for editing.
 * This redirects the document to edit that member.
 */
function get_member_edit_page () {
	$(this).disable();  // Avoid double-selection.
	document.location.pathname = "/members/" + $(this).val() + "/edit";
}

$(document).ready(function() {
	$('#EditMemberSelect').change(get_member_edit_page);
});
