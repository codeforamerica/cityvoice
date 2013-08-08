$(document).ready(function() { 
	$('#appendedInputButton')
    .typeahead({name: "Address", prefetch: 'assets/property_addresses.json' })
    .bind('typeahead:selected', function(obj, datum) {
      window.location = (window.location.origin + "/properties/" + datum.value.replace(/\s/g,"-")); 
  }); 
});
