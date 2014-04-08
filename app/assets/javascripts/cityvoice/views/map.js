Cityvoice.Views.Map = Backbone.View.extend({
  el: '#cityvoice-map',

  initialize: function(options){
    this.tileLayerUrl = options.tileLayerUrl;
    this.attributionText = options.attributionText;
    this.maxZoom = options.maxZoom;
  },

  _getMapOptions: function(){
    return {
      center: this.collection.getCenter(),
      zoom: this.maxZoom
    };
  },

  _getTileLayerOptions: function(){
    return {
      attribution: this.attributionText,
      zoom: this.maxZoom
    };
  },

  createMap: function(){
    if (!this.leafletTileLayer) { this.createTileLayer(); }
    this.leafletMap = L.map(this.$el[0], this._getMapOptions());
    this.leafletTileLayer.addTo(this.leafletMap);
  },

  createTileLayer: function(){
    this.leafletTileLayer = L.tileLayer(this.tileLayerUrl, this._getTileLayerOptions());
  },

  render: function(){
    if (!this.leafletMap) { this.createMap(); }
    return this;
  }
});
