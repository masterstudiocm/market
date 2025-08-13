import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return (connectivityResult.contains(ConnectivityResult.none)) ? false : true;
}
