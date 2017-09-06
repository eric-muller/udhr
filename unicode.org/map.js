 $(document).ready(function() {
   var map=L.map('map').setView([0,0], 1);

   L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', 
      { maxZoom: 18,
        attribution: 'Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
        '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'
        }).addTo(map);

   var markers = L.markerClusterGroup({ disableClusteringAtZoom: 6 });

   for (var i = 0; i < mapMarkers.length; i++) {
     var a = mapMarkers[i];

     var x = "";
     var xsep = "";

     var title = "";
     var titleSep = "";

     for (var j = 0; j < a[2].length; j++) {
       var e = a[2][j];
       var file = e[0];
       var name = e[1];
       var iso639 = e[2];
       var bpc47 = e[3];
       var ohchr = e[4];
       var stage = e[5];
       var notes = e[6];

       title = title + titleSep + name;
       titleSep = ", ";

       x = x + xsep;

       if (stage > 2) {
         x = x + "<a href='http://www.unicode.org/udhr/d/udhr_" + file + ".html'>" + name + "</a>" }
       else {
         x = x + name; }

       x = x + " <a href='translations.html?search=" + name + "'>(details)</a>";

       xsep = "<br/>"; }

     var marker = L.marker(new L.LatLng(a[0], a[1]), { title: title });
     marker.bindPopup (x);
     markers.addLayer(marker); }

   map.addLayer(markers);
   })
