
import 'package:customer/core/domain/usecase/usecase.dart';
import 'package:customer/core/presentation/utils/task_runner.dart';
import 'package:geolocator/geolocator.dart';

/// A service to handle device location requests and status checks.
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  /// Check the status of location permission.
  ResultFuture<LocationPermission> checkPermission() async {
    return runTask(() => Geolocator.checkPermission());
  }

  /// Request location permission.
  ResultFuture<LocationPermission> requestPermission() async {
    return runTask(() => Geolocator.requestPermission());
  }

  /// Check if location services are enabled.
  ResultFuture<bool> isLocationServiceEnabled() async {
    return runTask(() => Geolocator.isLocationServiceEnabled());
  }

  /// Open the location settings.
  ResultFuture<bool> openLocationSettings() async {
    return runTask(() => Geolocator.openLocationSettings());
  }

  /// Get the current position.
  ResultFuture<Position> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    return runTask(() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      } 

      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: accuracy),
      );
    });
  }

  /// Get the last known position.
  ResultFuture<Position?> getLastKnownPosition() async {
    return runTask(() => Geolocator.getLastKnownPosition());
  }

  /// Get a stream of position updates.
  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 0,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }
}
