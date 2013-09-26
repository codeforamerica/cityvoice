$(document).ready(function() {
    $('#appendedInputButton')
    .typeahead({name: "Address", prefetch: "subjects.json?only=name" })
    .bind('typeahead:selected', function(obj, datum) {
      window.location = ("/subjects/" + datum.value.replace(/\s/g,"-"));
  });
});
