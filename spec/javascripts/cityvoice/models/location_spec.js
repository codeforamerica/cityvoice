describe("Cityvoice.Models.Location", function() {
  beforeEach(function(){
    this.jsonFixture = loadJSONFixtures('location.json');
    jasmine.Ajax.install();
  });

  afterEach(function() {
    jasmine.Ajax.uninstall();
  });

  it("instantiates", function() {
    expect(new Cityvoice.Models.Location()).toBeTruthy();
  });

  describe("an instantiated copy", function(){
    beforeEach(function(){
      this.location = new Cityvoice.Models.Location();
      this.location.set(this.jsonFixture['location.json']);
    });

    describe("#toLatLng", function(){
      it("converts to a latLng", function(){
        expect(this.location.toLatLng().lat).toEqual(1);
        expect(this.location.toLatLng().lng).toEqual(2);
      });
    });

    describe("#toContent", function(){
      it("converts to a latLng", function(){
        expect(this.location.toContent()).toEqual('<a href="http://test.host/locations/123-Main-Street">123 Main Street</a>');
      });
    });
  });
});
