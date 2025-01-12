function doit(missionID, planetID) {
	$.getJSON("game.php?page=fleetAjax&ajax=1&mission="+missionID+"&planetID="+planetID, function(data)
	{
		$('#slots').text(data.slots);
		if(typeof data.ships !== "undefined")
		{
			$.each(data.ships, function(elementID, value) {
				$('#elementID'+elementID).text(number_format(value));
			});
		}
		
		var statustable	= $('#fleetstatusrow');
		var messages	= statustable.find("~tr");
		if(messages.length == MaxFleetSetting) {
			messages.filter(':last').remove();
		}
		var element		= $('<td />').attr('colspan', 8).attr('class', data.code == 600 ? "success" : "error").text(data.mess).wrap('<tr />').parent();
		statustable.removeAttr('style').after(element);
	});
}


function galaxy_submit(value) {
    $('#auto').attr('name', value);
    
    $.ajax({
        type: "POST",
        url: $('#galaxy_form').attr('action') + '&ajax=2',
        data: $('#galaxy_form').serialize(),
        success: function(response) {
            // Handle the response here
			$("#galaxy_table_wrapper").html(response);
            console.log("Form submitted successfully");
            // You can update the page content with the response if needed
        },
        error: function(xhr, status, error) {
            console.error("Error submitting form:", error);
        }
    });
}