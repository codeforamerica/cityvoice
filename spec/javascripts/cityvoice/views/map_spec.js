describe("Cityvoice.Views.Map", function() {
  beforeEach(function() {
    setFixtures("<div id='cityvoice-map'></div>");
    this.leaflet = spyOn(L, "map");
    var fakeLayer = {addTo: function(m){ return true; }};
    this.fakeLayerAddToSpy = spyOn(fakeLayer, "addTo");
    this.leafletLayer = spyOn(L, "tileLayer").andReturn(fakeLayer);
    var fakeMarker = {bindPopup: function(){ return this; }, addTo: function(){}};
    this.fakeMarkerAddToSpy = spyOn(fakeMarker, "addTo");
    this.leafletMarker = spyOn(L, "marker").andReturn(fakeMarker);
  })

  it("instantiates", function() {
    expect(new Cityvoice.Views.Map({})).toBeTruthy();
  });

  describe("an instantiated copy", function(){
    beforeEach(function(){
      var FakeCollection = Backbone.Collection.extend({
        getCenter: function(){ return [1,2]; },
        getBounds: function(){ return 'bounds'; }
      });
      this.map = new Cityvoice.Views.Map({
        collection: new FakeCollection(),
        attributionText: "attributionText",
        tileLayerUrl: "http://example.com/tiles",
        maxZoom: "zoom"
      });
    });

    describe("#render", function(){
      beforeEach(function(){
        this.fitBoundsSpy = jasmine.createSpy('fitBounds');
        this.leaflet.andReturn({fitBounds: this.fitBoundsSpy});
        var FakeModel = Backbone.Model.extend({toLatLng: function(){ return {lat: 1, lng: 2}; }, toContent: function(){ return "content"; }});
        this.map.collection.add(new FakeModel());
      });

      it("sets a reference to the leaflet map", function(){
        expect(this.map.leafletMap).toBeFalsy();
        this.map.render();
        expect(this.map.leafletMap).toBeTruthy();
      });

      it("returns a reference to the map view", function(){
        expect(this.map.render()).toEqual(this.map);
      });

      it("adds a marker to the map", function(){
        this.map.render();
        expect(this.fakeMarkerAddToSpy).toHaveBeenCalledWith(this.map.leafletMap);
        expect(this.leafletMarker).toHaveBeenCalledWith({lat: 1, lng: 2});
      });

      it("fits the view of the map to the bounds of the collection", function(){
        this.map.render();
        expect(this.fitBoundsSpy).toHaveBeenCalledWith('bounds', { reset: true });
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
