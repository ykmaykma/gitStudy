
/**
Constructor
Do not call Function in Constructor.
*/
@class MapView()
{
	@super();

	this.title = '';
	this.lat = 0;
	this.lng = 0;
	this.calcMode = false;
	this.latlngArr = new Array();

}
@extends AView;

MapView.thisObj = null;
MapView.isLoaded = false;
MapView.initMap = function()
{
	MapView.isLoaded = true;
	MapView.thisObj.onLoadMap();
};

@function MapView:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	MapView.thisObj = this;
	if(!MapView.isLoaded) $('<script async defer src="https://maps.googleapis.com/maps/api/js?key='+Define.MAP_KEY+'&callback=MapView.initMap"></script>').appendTo('head');

};

@function MapView:setMapInfo(mapInfoArr)
{
	this.title = mapInfoArr[0];
	this.lat = mapInfoArr[1];
	this.lng = mapInfoArr[2];
	
	if(MapView.isLoaded) this.onLoadMap();
	
};

@function MapView:calcNearPlace(map, latlngArr)
{

	var minDist = 10000000000000;
	var resultLoc = null;
	if(navigator.geolocation)
	{
		navigator.geolocation.getCurrentPosition(function(position) {
			var curLatLng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
			for(var i = 0; i<latlngArr.length; i++)
			{
				var locationlatlng = new google.maps.LatLng(latlngArr[i]['g_lat'], latlngArr[i]['g_lng']);
    			distance = google.maps.geometry.spherical.computeDistanceBetween(curLatLng, locationlatlng);		
				if(minDist > distance)
				{
					minDist = distance;
					resultLoc = locationlatlng;
				}
			}
			
			var directionsService = new google.maps.DirectionsService;
			var directionsDisplay = new google.maps.DirectionsRenderer;
			directionsDisplay.setMap(map);
			directionsService.route(
			{
				origin: curLatLng,
				destination: resultLoc,
				travelMode: google.maps.TravelMode.DRIVING
			},
			function(response, status)
			{
				if(status === google.maps.DirectionsStatus.OK)
				{
					directionsDisplay.setDirections(response);
				}
				else
				{
					//window.alert('Directions request failed due to ' + status);
				}
			});
		});
	}
	else AToast.show('');
	
};

@function MapView:onLoadMap()
{
	var thisObj = this;
	
	this.$ele.children().remove();
	
	var map = new google.maps.Map(this.element, {
		center: {lat: thisObj.lat, lng: thisObj.lng},
		scrollwheel: false,
		zoom: 18,
		panControl: false,
		zoomControl: false,
		mapTypeControl: false,
		scaleControl: false,
		streetViewControl: false,
		overviewMapControl: false
	});
	
	if(this.calcMode) this.calcNearPlace(map, this.latlngArr);
	else
	{
		var marker = new google.maps.Marker({
			map: map,
			position: {lat: thisObj.lat, lng: thisObj.lng},
			title: thisObj.title
		});	
	}
	
	
	//marker.setAnimation(google.maps.Animation.BOUNCE);
	
};