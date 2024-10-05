import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:oilie_butt_skater_app/components/alert.dart';
import 'package:oilie_butt_skater_app/components/text_custom.dart';
import 'package:oilie_butt_skater_app/constant/color.dart';
import 'package:oilie_butt_skater_app/pages/room/image_picker.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // สร้างตัวแปรสำหรับเก็บพิกัดเริ่มต้น
  LatLng _currentPosition = const LatLng(16.252001, 103.253198);
  LatLng _markerPosition = const LatLng(51.509364, -0.128928);
  late final MapController _mapController;
  // ฟังก์ชันสำหรับเปลี่ยนตำแหน่งของ Marker
  void _changeCurrentPosition(LatLng newPosition) {
    setState(() {
      _currentPosition = newPosition;
    });
    _mapController.move(newPosition, 18);
  }

  void _changeMarkerPosition(LatLng newPosition) {
    setState(() {
      _markerPosition = newPosition;
    });
  }

  // ฟังก์ชันสำหรับการพิมพ์พิกัดของ Marker
  void _getMarkerPosition() {
    print(
        'Current Position: Latitude: ${_currentPosition.latitude}, Longitude: ${_currentPosition.longitude}');
    print(
        'Current Marker Position: Latitude: ${_markerPosition.latitude}, Longitude: ${_markerPosition.longitude}');
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ตรวจสอบว่า location service ถูกเปิดหรือไม่
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ถ้าไม่เปิด location service ให้แจ้งเตือนผู้ใช้
      print('Location services are disabled.');
      return;
    }

    // ตรวจสอบและขอ permission สำหรับการเข้าถึงตำแหน่ง
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ถ้าผู้ใช้ปฏิเสธ permission
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // ถ้าผู้ใช้ปฏิเสธ permission ถาวร
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // ถ้าได้ permission แล้ว ให้หาตำแหน่งปัจจุบัน
    Position position = await Geolocator.getCurrentPosition();

    // อัปเดตพิกัดตำแหน่งในแผนที่
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _changeCurrentPosition(_currentPosition);
      print(_currentPosition);
    });
  }

  @override
  void initState() {
    super.initState();
    _determinePosition(); // เรียกใช้ฟังก์ชันเมื่อเริ่มต้นแอป
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: AppColors.backgroundColor,
        actions: [
          TextCustom(
            size: 17,
            text: 'ถัดไป',
            color: AppColors.secondaryColor,
            onTap: () {
              if (_markerPosition.latitude == 51.509364 &&
                  _markerPosition.longitude == -0.128928) {
                print("marker don't move");
                Alert().newWarning(context, "ระวัง", "โปรดเลือกตำแหน่ง");
              } else {
                var data = {
                  'latitude': _markerPosition.latitude,
                  'longitude': _markerPosition.longitude
                };
                Get.to(ImagePickerRoom(data: data));
              }
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentPosition, // ใช้ตำแหน่งปัจจุบันเป็นศูนย์กลาง
          zoom: 25.0,
          minZoom: 10.0,
          maxZoom: 18,
          onTap: (tapPosition, LatLng newPosition) {
            // เปลี่ยนตำแหน่ง marker เมื่อแตะที่แผนที่
            _changeMarkerPosition(newPosition);
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/ddza1992/clnbhdf2k03jj01nz09jt3lww/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: const {
              'accessToken':
                  'pk.eyJ1IjoiZGR6YTE5OTIiLCJhIjoiY20xdXdtdzljMDVvYTJscXd0d2FrOWwwaiJ9.ZlGXI4c5GJj9qxwgGRQYwg',
              'id': 'mapbox.mapbox-street-v8'
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _currentPosition, // ตำแหน่งผู้ใช้
                builder: (context) => Transform.scale(
                  scale: 0.8, // ปรับขนาดให้เล็กลงที่นี่
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                      // เพิ่มเงา
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // สีเงา
                          spreadRadius: 2, // ขยายขนาดเงา
                          blurRadius: 5, // ทำให้เงานุ่มนวล
                          offset: const Offset(0, 2), // ตำแหน่งของเงา
                        ),
                      ],
                    ),
                    child: Container(
                      width: 10.0, // วงกลมด้านในสีขาว
                      height: 10.0,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              Marker(
                point: _markerPosition,
                builder: (context) => Stack(
                  alignment: Alignment.center, // จัดให้อยู่ตรงกลาง marker
                  children: [
                    // Marker หลัก
                    Transform.scale(
                      scale: 2.8,
                      child: IconButton(
                        onPressed:
                            _getMarkerPosition, // แสดงตำแหน่งเมื่อคลิกที่ marker
                        icon: SvgPicture.asset(
                          'assets/icons/marker.svg',
                          fit: BoxFit.cover,
                          color: Colors.red,
                        ), // ใช้ icon ของ Google Maps
                        iconSize: 50.0, // ปรับขนาด icon ที่นี่
                      ),
                    ),
                    // รูปภาพหรือ widget ที่ต้องการวางไว้บน marker
                    Positioned(
                      top: 0, // ปรับตำแหน่งให้อยู่ด้านบนของ marker
                      child: SvgPicture.asset(
                        'assets/icons/skateboarding.svg', // เส้นทางของรูปที่ต้องการแสดง
                        width: 20, // ปรับขนาดตามที่ต้องการ
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
