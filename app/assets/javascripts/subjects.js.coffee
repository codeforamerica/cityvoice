#= require audiojs

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  loadData = (json_representation) ->
      latitude = json_representation.lat
      longitude = json_representation.long
      window.map = L.mapbox.map('map',mapboxMapID).setView([latitude, longitude], 16)
      L.Icon.Default.imagePath = "/assets"
      marker = L.marker([latitude, longitude]).addTo(map)

  $(document).ready ->
    $.ajax({
      url: document.URL,
      cache: false,
      dataType: 'json',
      type: 'GET',
      success: (data) ->
        loadData(data)
    })
