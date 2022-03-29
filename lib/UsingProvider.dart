import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';
class ChangeData extends ChangeNotifier{
  String location ='Null, Press Button';
  final Distance distance=Distance();
  final lat1=28.6445433;
  final long1=77.3264255;
  num km=0;
  num meter=0;
  bool? isselected=false;
  String Address = 'search';
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  }
/*
  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    //print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    *//*if(isselected==true){
      km =distance.as(LengthUnit.Kilometer, LatLng(lat1, long1), LatLng(position.latitude, position.longitude));
      //print('Distance in km $km');
      meter=distance(LatLng(lat1, long1),LatLng(lat2, long2));
      //print('Distance in meter $meter');
    }
    else
    {
      debugPrint("Dont print distance kilometer");
      km=0;
      meter=0;
    }*//*
  }*/
      notifyListeners();
}
class ProvData extends StatefulWidget {
  const ProvData({Key? key}) : super(key: key);

  @override
  State<ProvData> createState() => _ProvDataState();
}

class _ProvDataState extends State<ProvData> {
  ChangeData cd=ChangeData();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>ChangeData(),
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Attendance App'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Coordinates Points',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                Consumer(builder: (context,changeData,_)=>Text(cd.location)),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Work from Home :',style: TextStyle(color: Colors.green,fontSize: 20)),
                    Checkbox(
                      /*activeColor: Colors.white,
              checkColor: Colors.blue,*/
                      value: cd.isselected,
                      onChanged: (valuesecond){
                        setState(() {
                          cd.isselected=valuesecond;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Consumer(builder: (context,changedata,_)=>ElevatedButton(onPressed: ()async{
                  Position position=await cd._getGeoLocationPosition();
                  cd.location ='Lat: ${position.latitude} , Long: ${position.longitude}';
                  if(cd.isselected==false){
                    cd.meter=cd.distance(LatLng(cd.lat1, cd.long1),LatLng(position.latitude, position.longitude));
                    if(cd.meter<=50)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Container(
                        child: const Text('Present'),
                      )));
                    }
                    //print('Distance in meter $meter');
                  }
                  else
                  {
                    debugPrint("Dont print distance kilometer");
                    cd.km=0;
                    cd.meter=0;
                  }

                }, child: const Text('Get Location'),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
