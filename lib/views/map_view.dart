// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/map_controller.dart';

class MapView extends StatelessWidget {
  final MapController controller = Get.put(MapController());

   MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.currentLocation.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return GoogleMap(
          onMapCreated: (mapCtrl) => controller.mapController = mapCtrl,
          initialCameraPosition: CameraPosition(
            target: controller.currentLocation.value!,
            zoom: 14,
          ),
          markers: controller.markers.value,
          polylines: controller.polylines.value,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onTap: (LatLng tappedPoint) {
            controller.destination.value = tappedPoint;
            controller.getRoute(controller.currentLocation.value!, tappedPoint);
          },
        );
      }),
    );
  }
}
