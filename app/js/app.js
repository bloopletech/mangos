var store = null;

$(function() {
  $(document).on("dragstart", "a, img", false);

});

window.addEventListener('polymer-ready', function(e) {
  console.log("hit polymer-ready");
  $.getJSON("data.json").done(function(data) {
    console.log("boop");
    if(data.length == 0) alert("No data.json, or data invalid.");

    store = data;

    window.router = new router();
    router.init();
    if(location.hash == "#" || location.hash == "") location.hash = "#index!1";
  });
});