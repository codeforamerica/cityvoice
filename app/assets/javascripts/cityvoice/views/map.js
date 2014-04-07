Cityvoice.Views.Map = Backbone.View.extend({
  el: '#cityvoice-map',

  initialize: function(options){
    this.tileLayerUrl = options.tileLayerUrl;
    this.attributionText = options.attributionText;
    this.maxZoom = options.maxZoom;
  },

  getMapOptions: function(){
    return {
      center: this.collection.getCenter(),
      zoom: this.maxZoom
    };
  },

  createMap: function(){
    if (!this.leafletTileLayer) { this.createTileLayer(); }
    this.leafletMap = L.map(this.$el[0], this.getMapOptions());
    this.leafletTileLayer.addTo(this.leafletMap);
  },

  getTileLayerOptions: function(){
    return {
      attribution: this.attributionText,
      zoom: this.maxZoom
    };
  },

  createTileLayer: function(){
    this.leafletTileLayer = L.tileLayer(this.tileLayerUrl, this.getTileLayerOptions());
  },

  render: function(){
    if (!this.leafletMap) { this.createMap(); }
    return this;
  }
});
