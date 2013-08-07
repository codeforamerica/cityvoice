window.map = L.mapbox.map('map','codeforamerica.map-stwhr1eg').setView([41.687, -86.254], 12);
var markers = new L.MarkerClusterGroup();
markers.addLayer(new L.marker([41.687, -86.254],[41.6871, -86.254],[41.6872, -86.254]));
markers.addLayer(new L.marker([41.6871, -86.254]));
markers.addLayer(new L.marker([41.6872, -86.254]));
map.addLayer(markers);
