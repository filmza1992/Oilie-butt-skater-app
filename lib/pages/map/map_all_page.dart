import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:oilie_butt_skater_app/api/api_room.dart';
import 'package:oilie_butt_skater_app/components/%E0%B8%B4%E0%B8%B5button_dialog.map.dart';
import 'package:oilie_butt_skater_app/controller/user_controller.dart';
import 'package:oilie_butt_skater_app/models/room_model.dart';
import 'package:oilie_butt_skater_app/models/user.dart';
import 'package:oilie_butt_skater_app/pages/room/room_detail_page.dart';

class MapAllPage extends StatefulWidget {
  const MapAllPage({
    super.key,
    required this.rooms,
  });

  final List<Room> rooms;
  @override
  State<MapAllPage> createState() => _MapAllPageState();
}

class _MapAllPageState extends State<MapAllPage> {
  LatLng _currentPosition = const LatLng(16.252001, 103.253198);
  final LatLng _markerPosition = const LatLng(16.252001, 103.253198);
  UserController userController = Get.find<UserController>();

  late final MapController _mapController;
  // ฟังก์ชันสำหรับเปลี่ยนตำแหน่งของ Marker
  void _changeCurrentPosition(LatLng newPosition) {
    setState(() {
      _currentPosition = newPosition;
    });
    _mapController.move(newPosition, 15);
  }

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

  Marker _buildCurrentUserMarker() {
    return Marker(
      point: _currentPosition, // ตำแหน่งผู้ใช้ปัจจุบัน
      builder: (context) => Transform.scale(
        scale: 0.8,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: Colors.white),
          ),
          child: Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  List<Marker> _buildOtherMarkers() {
    return widget.rooms.map((room) {
      return Marker(
        point: LatLng(double.parse(room.latitude),
            double.parse(room.longitude)), // สร้าง Marker สำหรับแต่ละจุด
        builder: (context) => Stack(
          alignment: Alignment.center, // จัดให้อยู่ตรงกลาง marker
          children: [
            // Marker หลัก
            Transform.scale(
                scale: 3.3,
                child: ButtonDialogMap(
                    room: room, type: 'join', roomType: 'public_room')),
            // รูปภาพหรือ widget ที่ต้องการวางไว้บน marker
            Positioned(
              top: 0, // ปรับตำแหน่งให้อยู่ด้านบนของ marker
              child: IgnorePointer(
                // ทำให้รูปภาพไม่รับคลิก
                child: ClipOval(
                  child: Image.network(
                    room.imageUrl, // รูปภาพที่ต้องการแสดงเพิ่มเติม
                    width: 20, // ปรับขนาดตามที่ต้องการ
                    height: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String formatDateInThai(DateTime dateTime) {
    // List ของชื่อเดือนภาษาไทย
    List<String> monthsInThai = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม'
    ];

    // วันที่ และ เดือน เป็นภาษาไทย
    String day = dateTime.day.toString();
    String month = monthsInThai[dateTime.month - 1]; // ใช้ index เริ่มจาก 0
    String year = (dateTime.year + 543).toString(); // เพิ่มปีพุทธศักราช

    return month;
  }

  Future<void> _enterRoom(Room room, User user, User owner) async {
    await ApiRoom.joinRoom(room, user);
    Get.to(RoomDetailPage(
      room: room,
      owner: owner,
      roomType: 'public_room',
    ));
  }

  @override
  void initState() {
    super.initState();
    _determinePosition(); // เรียกใช้ฟังก์ชันเมื่อเริ่มต้นแอป
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> allMarkers = [
      _buildCurrentUserMarker(),
      ..._buildOtherMarkers()
    ]; // รวม current marker กับ markers อื่น ๆ

    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentPosition, // ใช้ตำแหน่งปัจจุบันเป็นศูนย์กลาง
          zoom: 25.0,
          minZoom: 10.0,
          maxZoom: 18,
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
            markers: allMarkers, // แสดงผล Marker ทั้งหมด
          ),
        ],
      ),
    );
  }
}
