describe("Cityvoice.Collections.Locations", function() {
  beforeEach(function(){
    this.jsonFixtures = loadJSONFixtures('locations.json');
    jasmine.Ajax.stubRequest('/locations.json').andReturn({
      status: 200,
      responseText: JSON.stringify(this.jsonFixtures['locations.json'])
    });
    jasmine.Ajax.install();
  });

  afterEach(function() {
    jasmine.Ajax.uninstall();
  });

  it("instantiates", function() {
    expect(new Cityvoice.Collections.Locations()).toBeTruthy();
  });

  describe("an instantiated copy", function(){
    beforeEach(function(){
      this.locations = new Cityvoice.Collections.Locations();
    });

    describe("after fetching", function(){
      beforeEach(function(){
        runs(function(){ this.locations.fetch(); });
        waits();
      });

      it("loads data", function(){
        runs(function(){
          expect(this.locations.length).toEqual(1);
        });
      });

      describe("#getCenter", function(){
        it("returns the centroid", function(){
          runs(function(){
            expect(this.locations.getCenter().lat).toEqual(37);
            expect(this.locations.getCenter().lng).toEqual(-122);
          });
        });
      });
    });
  });
});
