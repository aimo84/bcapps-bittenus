<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<style type="text/css">
  html { height: 100% }
  body { height: 100%; margin: 0px; padding: 0px }
  #map_canvas { height: 100% }
</style>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false">
</script>
<script type="text/javascript">

var trafficOptions = {
    getTileUrl: function(coord, zoom) {
      return "http://test.barrycarter.info/bc-tiles-from-dir.pl?"+"zoom=" + zoom + "&x=" + coord.x + "&y=" + coord.y + "&client=api";
;
    },
    tileSize: new google.maps.Size(256, 256),
    opacity: 0.5
  };

var trafficMapType = new google.maps.ImageMapType(trafficOptions);
 
function initialize() {
  var myOptions = {
    zoom: 2,
    center: new google.maps.LatLng(0,0),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(document.getElementById("map_canvas"),
      myOptions);

  <?php $foo = rand(); ?>

  map.zoom = 2;
  map.center = new google.maps.LatLng(0,0);
  map.overlayMapTypes.insertAt(0, trafficMapType);
}

</script>
</head>
<body onload="initialize()">

<div id="map_canvas" style="width:100%; height:100%"></div>

</body>
</html>
