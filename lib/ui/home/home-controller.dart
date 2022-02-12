import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class HomeController {
    constructor() {}

    Future<LatLng> getClientLocation() async {

        LocationPermission permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied){
          await Geolocator.requestPermission();
        }
        var location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


        print(location);
        return LatLng(location.latitude, location.longitude);
    }
}
