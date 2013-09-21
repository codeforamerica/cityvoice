$(document).ready(function() {
    $('#appendedInputButton')
    .typeahead({name: "Address", prefetch: "subjects.json?only=name" })
    .bind('typeahead:selected', function(obj, datum) {
      window.location = (window.location.origin + "/properties/" + datum.value.replace(/\s/g,"-")); 
  }); 
});
