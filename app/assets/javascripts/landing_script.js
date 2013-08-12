var lats_longs;
function placeMarkers(dataArray) {
	lats_longs = dataArray;
	var markers = new L.MarkerClusterGroup( { showCoverageOnHover: false } );
	for(var i = 0; i < dataArray.length; i++) {
		var a = dataArray[i];
		var address = a[0];
		var marker = L.marker(new L.LatLng(a[1],a[2]) , { address: address } );
		marker.bindPopup("<a href=" + document.location.origin + "/properties/" + address.replace(/\s/g,"-") + ">" + address + "</a>");
		markers.addLayer(marker);
	}
	map.addLayer(markers);
}

$(document).ready(drawMap);

function drawMap () {
	console.log('drawMap')
	window.map = L.mapbox.map('map','codeforamerica.map-stwhr1eg').setView([41.665, -86.28], 13);
	$.getJSON('assets/lats_longs.json', success = placeMarkers);
	$( "#dialog" ).dialog();
	$( "#dialog" ).dialog({ width: 250 });
	$( "#dialog" ).dialog({ position: { my: "left top", at: "left+50 bottom+60", of: "head"} });
}
