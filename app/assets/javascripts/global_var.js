// Make a JSON representation of the Rails object available to the page
$.getJSON(document.URL, success = function(successObject) { json_representation = successObject; console.log(successObject) } );
