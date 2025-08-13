import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:dio/dio.dart';
import 'package:market/classes/connection.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';

import 'package:market/widgets/svg_icon.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class StoresPage extends StatefulWidget {
  const StoresPage({super.key});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List data = [];
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Location location = Location();
  LatLng? currentLocation;
  String directionUrl = '';

  Future<void> get() async {
    if (await checkConnectivity()) {
      String query = insertQuery('${App.domain}/api/page.php?action=get&id=3');
      try {
        final response = await Dio().get(query, options: Options(headers: App.headers));
        if (response.statusCode == 200) {
          var result = response.data;
          if (mounted) {
            setState(() {
              if (result['status'] == 'success') {
                data = result['result']['stores'];
              }
            });
          }
        } else {
          setState(() => serverError = true);
        }
      } catch (e) {
        setState(() => serverError = true);
        SnackbarGlobal.show(e.toString());
      }
    } else {
      setState(() => connectError = true);
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      _addMarkers();
      _getCurrentLocation();
    });
  }

  void directionUrlCreator(double lat, double lng) {
    setState(() {
      directionUrl = 'https://www.google.com/maps/dir//$lat,$lng/@$lat,$lng,14z?hl=az';
    });
  }

  void _addMarkers() {
    if (data.isNotEmpty) {
      for (var store in data) {
        markers.add(
          Marker(
            markerId: MarkerId(store['s_name_az']),
            position: LatLng(double.parse(store['s_lat']), double.parse(store['s_lng'])),
            infoWindow: InfoWindow(title: store['s_name_az'], snippet: store['s_address_az']),
            onTap: () {
              directionUrlCreator(store['s_lat'], store['s_lng']);
            },
          ),
        );
      }
      Future.delayed(Duration(milliseconds: 200), () {
        final bounds = MapUtils.boundsFromLatLngList(markers.map((loc) => loc.position).toList());
        final center = LatLng(
          (bounds.southwest.latitude + bounds.northeast.latitude) / 2,
          (bounds.southwest.longitude + bounds.northeast.longitude) / 2,
        );

        mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: center, zoom: 8.7)));
      });
    }
  }

  void _getCurrentLocation() async {
    var currentLocation = await location.getLocation();
    if (mounted) {
      setState(() {
        this.currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Mağazalarımız')),
      body: MsContainer(
        loading: loading,
        serverError: serverError,
        connectError: connectError,
        child: (data.isEmpty)
            ? Padding(padding: const EdgeInsets.all(20.0).r, child: Text('Heç bir nəticə tapılmadı.'))
            : Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const MsIndicator(),
                                Text('Xəritə yüklənir...', style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ),
                        GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: const CameraPosition(target: LatLng(40.37767, 49.89201), zoom: 9.0),
                          markers: markers,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          indoorViewEnabled: true,
                          trafficEnabled: true,
                          onTap: (data) {
                            directionUrlCreator(data.latitude, data.longitude);
                          },
                        ),
                        if (directionUrl != '') ...[
                          Positioned(
                            bottom: 10.0.r,
                            left: 10.0.r,
                            child: InkWell(
                              onTap: () {
                                if (directionUrl != '') {
                                  launchUrl(Uri.parse(directionUrl));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0).r,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.base,
                                  borderRadius: BorderRadius.circular(30.0).r,
                                  boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 0))],
                                ),
                                child: Row(
                                  children: [
                                    const MsSvgIcon(icon: 'assets/brands/google-maps.svg', size: 20.0),
                                    SizedBox(width: 5.0.r),
                                    Text(
                                      'Yol tarifi al',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    height: 220.r,
                    color: Theme.of(context).colorScheme.grey2,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(15.0).r,
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            mapController?.animateCamera(CameraUpdate.newLatLngZoom(markers.elementAt(index).position, 14.0));
                            mapController?.showMarkerInfoWindow(markers.elementAt(index).markerId);
                            directionUrlCreator(markers.elementAt(index).position.latitude, markers.elementAt(index).position.longitude);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 3 / 5,
                            padding: const EdgeInsets.all(15.0).r,
                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.base, borderRadius: BorderRadius.circular(10.0).r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data[index]['s_name_az'], style: Theme.of(context).textTheme.titleSmall, maxLines: 2),
                                SizedBox(height: 10.0.r),
                                Text(
                                  data[index]['s_address_az'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                SizedBox(height: 20.0.r),
                                Text(
                                  data[index]['s_phone'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0).r,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryColor,
                                    borderRadius: BorderRadius.circular(30.0).r,
                                  ),
                                  child: Text(
                                    'Xəritədə bax',
                                    style: TextStyle(color: Theme.of(context).colorScheme.oppotext, fontSize: 11.0.sp, height: 1.3),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(width: 15.0.r);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class MapUtils {
  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
}
