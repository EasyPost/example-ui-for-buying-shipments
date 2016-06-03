$(document).ready(function() {	
	$('#selector').on("change", function(value) {
		hideShowInput()
	});
});


function hideShowInput(){
	if( $('#selector').val() === "parcel") {
		$('#hide-input').show();
	}
	else{
		$('#hide-input').hide();
	}
}