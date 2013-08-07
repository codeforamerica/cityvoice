window.map = L.mapbox.map('map','codeforamerica.map-stwhr1eg').setView([41.687, -86.254], 12);

var lats_longs;
function placeMarkers(dataArray) {
	lats_longs = dataArray;
	var markers = new L.MarkerClusterGroup();
	for(var i = 0; i < dataArray.length; i++) {
		var a = dataArray[i];
		var address = a[0];
		var marker = L.marker(new L.LatLng(a[1],a[2]) , { address: address } );
		marker.bindPopup("<a href=" + document.location.origin + "/properties/" + address.replace(/\s/g,"-") + ">" + address + "</a>");
		markers.addLayer(marker);
	}
	//markers.addLayer(new L.marker([41.6871, -86.254]));
	//markers.addLayer(new L.marker([41.6872, -86.254]));
	map.addLayer(markers);
}

$.getJSON('assets/lats_longs.json', success = placeMarkers)
