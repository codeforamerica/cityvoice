var lats_longs;
function placeMarkers(dataArray) {
	lats_longs = dataArray;
  if(monroePilot) {
    for(var i = 0; i < dataArray.length; i++) {
      var a = dataArray[i];
      var address = a[0];
      var mapIcon = L.icon({
          iconUrl: '/assets/marker-icon-vacant.png',
          shadowUrl: '/assets/marker-shadow.png',
          iconAnchor:   [0, 0], // point of the icon which will correspond to marker's location
          shadowAnchor: [4, 62],  // the same for the shadow
          popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor
      });
      // Turn on below once we've fixed the positioning and have implemented color icons
      //var marker = L.marker(new L.LatLng(a[1],a[2]) , {icon: mapIcon} , { address: address });
      var marker = L.marker(new L.LatLng(a[1],a[2]) , { address: address });
      marker.bindPopup("<a href=" + document.location.origin + "/properties/" + address.replace(/\s/g,"-") + ">" + address + "</a>");
      marker.addTo(map);
    }
  }
  else {
    var markers = new L.MarkerClusterGroup( { showCoverageOnHover: false } );
    for(var i = 0; i < dataArray.length; i++) {
      var a = dataArray[i];
      var address = a[0];
      var mapIcon = L.icon({
          iconUrl: '/assets/marker-icon-vacant.png',
          shadowUrl: '/assets/marker-shadow.png',
          iconAnchor:   [10, 7], // point of the icon which will correspond to marker's location
          shadowAnchor: [10, 7]
      });
      // Turn on below once we've fixed the positioning and have implemented color icons
      //var marker = L.marker(new L.LatLng(a[1],a[2]) , {icon: mapIcon} , { address: address } );
      var marker = L.marker(new L.LatLng(a[1],a[2]) , { address: address } );
      marker.bindPopup("<a href=" + document.location.origin + "/properties/" + address.replace(/\s/g,"-") + ">" + address + "</a>");
      markers.addLayer(marker);
    }
    map.addLayer(markers);
  }
}




$(document).ready(drawMap);

function drawMap () {
	console.log('drawMap')
  if(monroePilot) {
    window.map = L.mapbox.map('map','codeforamerica.map-stwhr1eg').setView([41.668, -86.246], 16);
  }
  else {
    window.map = L.mapbox.map('map','codeforamerica.map-stwhr1eg').setView([41.665, -86.28], 13);
  }
	$.getJSON('assets/lats_longs.json', success = placeMarkers);
	$( "#dialog" ).dialog();
	$( "#dialog" ).dialog({ width: 295 });
	$( "#dialog" ).dialog({ position: { my: "left top", at: "left+50 bottom+60", of: "head"} });
}
