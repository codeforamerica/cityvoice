Cityvoice.Collections.Locations = Backbone.Collection.extend({
  url: '/locations.json',
  model: Cityvoice.Models.Location,

  parse: function(response) {
    return response.features;
  },
  getCenter: function() {
    return this.getBounds().getCenter();
  },
  getBounds: function() {
    var latlngs = this.map(function(model){
      return model.toLatLng();
    });
    return L.latLngBounds(latlngs);
  }
});
