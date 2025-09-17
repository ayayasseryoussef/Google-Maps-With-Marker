import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_with_marker/core/constants.dart';
import 'package:location/location.dart';
import '../services/directions_service.dart';

class MapController extends GetxController {
  final DirectionsService directionsService = DirectionsService();

  var currentLocation = Rxn<LatLng>();
  var destination = Rxn<LatLng>();
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs;
  GoogleMapController? mapController;

  final Location location = Location();

  @override
  void onInit() {
    super.onInit();
    _checkPermissionsAndGetLocation();
  }

  Future<void> _checkPermissionsAndGetLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final locData = await location.getLocation();
    currentLocation.value = LatLng(locData.latitude!, locData.longitude!);
    _addUserMarker(currentLocation.value!);

    location.onLocationChanged.listen((newLoc) {
      currentLocation.value = LatLng(newLoc.latitude!, newLoc.longitude!);
      _addUserMarker(currentLocation.value!);

      mapController?.animateCamera(
        CameraUpdate.newLatLng(currentLocation.value!),
      );

      if (destination.value != null) {
        getRoute(currentLocation.value!, destination.value!);
      }
    });
  }

  void _addUserMarker(LatLng pos) {
    markers.removeWhere((m) => m.markerId.value == "user");
    markers.add(
      Marker(
        markerId: const MarkerId("user"),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    markers.refresh();
  }

  Future<void> getRoute(LatLng origin, LatLng dest) async {
     String apiKey;
    if(kIsWeb) {
   apiKey= AppConstants.webGoogleApiKey; }
   else{
    apiKey=AppConstants.googleApiKey;
   }

    final data = await directionsService.getRoute(
      apiKey: apiKey,
      originLat: origin.latitude,
      originLng: origin.longitude,
      destLat: dest.latitude,
      destLng: dest.longitude,
    );

    if (data != null) {
      final points = data["routes"][0]["overview_polyline"]["points"];
      final polylinePoints = _decodePolyline(points);

      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          color: AppConstants.lineColor,
          width: 5,
          points: polylinePoints,
        ),
      );
      polylines.refresh();

      markers.removeWhere((m) => m.markerId.value == "destination");
      markers.add(
        Marker(
          markerId: const MarkerId("destination"),
          position: dest,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
      markers.refresh();
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }
}
