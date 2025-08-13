import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/snackbar.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  GoogleMapController? mapController;
  bool loading = false;
  LatLng _pickedLocation = LatLng(40.409264, 49.867092);
  String locationName = 'Təyin edilməyib';
  List searchLocations = [];
  final TextEditingController textController = TextEditingController();

  Future<void> get(String keyword) async {
    Map result = await httpRequest('${App.domain}/api/locations.php?action=get&keyword=$keyword', snackbar: true);
    final payload = result['payload'];
    if (payload['status'] == 'success') {
      setState(() => searchLocations = payload['result']);
    } else if (payload['status'] == 'error') {
      SnackbarGlobal.show(payload['error']);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getLocation(LatLng location) async {
    setState(() {
      _pickedLocation = location;
      loading = true;
    });
    setLocaleIdentifier('az_az');
    List<Placemark> placemarks = await placemarkFromCoordinates(_pickedLocation.latitude, _pickedLocation.longitude);
    setState(() {
      locationName = '${placemarks.first.locality!}, ${placemarks.first.subLocality}, ${placemarks.first.street}';
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(
        title: TextField(
          controller: textController,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxHeight: 45.0.r),
            hintText: 'Xəritə üzərində axtar...',
            hintStyle: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w400),
            prefixIcon: SizedBox(
              width: 50.0.r,
              child: MsSvgIcon(icon: 'assets/icons/search.svg', color: Theme.of(context).colorScheme.grey4),
            ),
          ),
          onChanged: (value) {
            get(value);
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(target: _pickedLocation, zoom: 12.0),
            onTap: getLocation,
            markers: {Marker(markerId: MarkerId('pickedLocation'), position: _pickedLocation)},
          ),
          if (textController.text.isNotEmpty) ...[
            Positioned.fill(child: Container(color: Colors.black.withValues(alpha: .5))),
            Positioned(
              child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.base,
                constraints: BoxConstraints(maxHeight: 300.0.r),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var item in searchLocations) ...[
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              textController.text = '';
                              FocusManager.instance.primaryFocus?.unfocus();
                              mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(item['lat'], item['lng']), 14.0));
                              getLocation(LatLng(item['lat'], item['lng']));
                              setState(() {
                                searchLocations = [];
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20.0).r,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name'], style: TextStyle(fontWeight: FontWeight.w500)),
                                  SizedBox(height: 3.0.r),
                                  Text(item['address']),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0).r,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seçilən ərazi:', style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(height: 5.0.r),
                    Text((loading) ? 'Hesablanır...' : locationName),
                  ],
                ),
              ),
              SizedBox(width: 15.0.r),
              MsButton(
                backgroundColor: Theme.of(context).colorScheme.primaryColor,
                onTap: () async {
                  if (locationName == 'Təyin edilməyib') {
                    SnackbarGlobal.show('Heç bir ünvan seçməmisiniz.');
                  } else if (!loading) {
                    Navigator.pop(context, {'location': locationName, 'latlng': _pickedLocation});
                  }
                },
                title: 'Təsdiqlə',
                loading: loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
