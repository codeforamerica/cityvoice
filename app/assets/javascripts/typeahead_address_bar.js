$(document).ready(function() {
    $('#appendedInputButton')
    .typeahead({name: "Address", prefetch: "/locations.json?only=name" })
    .bind('typeahead:selected', function(obj, datum) {
      window.location = ("/locations/" + datum.value.replace(/\s/g,"-"));
  });
});
