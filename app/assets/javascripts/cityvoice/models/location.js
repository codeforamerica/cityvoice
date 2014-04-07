Cityvoice.Models.Location = Backbone.Model.extend({
  toLatLng: function(){
    var coordinates = this.attributes.geometry.coordinates;
    return L.latLng(coordinates[0], coordinates[1]);
  }
});
