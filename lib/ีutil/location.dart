
import 'package:geolocator/geolocator.dart';

class Location {
  // Get current date and time
  static 
Future<Position?> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // ตรวจสอบว่าเปิด location service หรือไม่
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
    return null;
  }

  // ตรวจสอบและขอ permission สำหรับ location
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied.');
    return null;
  }

  // ได้รับ permission และหาตำแหน่งปัจจุบัน
  return await Geolocator.getCurrentPosition();
}

 
}

