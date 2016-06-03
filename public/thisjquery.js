$(document).ready(function() {	
	$('#selector').on("change", function(value) {
		var $this = $(this),
     	value = $this.val();
		hideShowInput(value)
	});
});


function hideShowInput(option){
	if( option === "Parcel") {
		$('#hide-input').show();
	}
	else{
		$('#hide-input').hide();
	}
}
