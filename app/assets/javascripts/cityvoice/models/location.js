Cityvoice.Models.Location = Backbone.Model.extend({
  toLatLng: function(){
    var coordinates = this.get("geometry").coordinates;
    return L.latLng(coordinates[0], coordinates[1]);
  },
  toContent: function(){
    var properties = this.get("properties");
    return ['<a href="', properties.url, '">', properties.name, '</a>'].join("");
  }
});
