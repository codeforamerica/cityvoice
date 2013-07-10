# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery () ->
	if $("body.subjects").length > 0
		window.map = L.map('map').setView([41.68, -86.25], 14)
		L.tileLayer('http://{s}.tile.cloudmade.com/540fa91132c54177ac2cce3a415e5ff0/997/256/{z}/{x}/{y}.png', {
	    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
	    maxZoom: 18
		}).addTo(map);
		polygon = L.polygon([
		    [41.68, -86.25],
		    [41.683, -86.253],
		    [41.688, -86.258]
		]).addTo(map);
