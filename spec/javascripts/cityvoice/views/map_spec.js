describe("Cityvoice.Views.Map", function() {
  beforeEach(function() {
    setFixtures("<div id='cityvoice-map'></div>");
    this.leaflet = spyOn(L, "map");
    var fakeLayer = {addTo: function(m){ return true; }};
    this.fakeLayerAddToSpy = spyOn(fakeLayer, "addTo")
    this.leafletLayer = spyOn(L, "tileLayer").andReturn(fakeLayer);
  })

  it("instantiates", function() {
    expect(new Cityvoice.Views.Map({})).toBeTruthy();
  });

  describe("an instantiated copy", function(){
    beforeEach(function(){
      var FakeCollection = Backbone.Collection.extend({getCenter: function(){ return [1,2]; }});
      this.map = new Cityvoice.Views.Map({
        collection: new FakeCollection(),
        attributionText: "attributionText",
        tileLayerUrl: "http://example.com/tiles",
        maxZoom: "zoom"
      });
    });

    describe("#render", function(){
      beforeEach(function(){
        this.leaflet.andReturn(true);
      });

      it("sets a reference to the leaflet map", function(){
        expect(this.map.leafletMap).toBeFalsy();
        this.map.render();
        expect(this.map.leafletMap).toBeTruthy();
      });

      it("returns a reference to the map view", function(){
        expect(this.map.render()).toEqual(this.map);
      });
    });

    describe("#$el", function(){
      it("is set to the proper element", function() {
        expect($("#cityvoice-map")).toEqual(this.map.$el)
      });
    });

    describe("#createMap", function(){
      beforeEach(function(){
        this.$el = $("#cityvoice-map", fixture.el);
      });

      it("instantiates a leaflet map", function(){
        this.map.createMap();
        expect(this.leaflet).toHaveBeenCalledWith(this.$el[0], {center: [1,2], zoom: "zoom"});
      });

      it("instantiates a leaflet tile layer", function(){
        this.map.createMap();
        expect(this.leafletLayer).toHaveBeenCalledWith("http://example.com/tiles", {attribution: "attributionText", zoom: "zoom"});
      });

      it("adds the leaflet tile layer to the map", function(){
        this.leaflet.andReturn("leaflet map goes here");
        this.map.createMap();
        expect(this.fakeLayerAddToSpy).toHaveBeenCalledWith("leaflet map goes here");
      });

      it("sets a reference to the leaflet map", function(){
        this.leaflet.andReturn("leaflet map goes here");
        this.map.createMap();
        expect(this.map.leafletMap).toEqual("leaflet map goes here");
      });
    });
  });
});
