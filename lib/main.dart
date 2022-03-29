import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

import 'package:locationinfo/UsingProvider.dart';



void main() {
  runApp(ProvData());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

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

  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    //print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    /*if(isselected==true){
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
    }*/
    setState(()  {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Coordinates Points',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            Text(location,style: const TextStyle(color: Colors.black,fontSize: 16),),
            const SizedBox(height: 10,),
            const Text('ADDRESS',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            Text(Address),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Work from Home :',style: TextStyle(color: Colors.green,fontSize: 20)),
                Checkbox(
                  /*activeColor: Colors.white,
              checkColor: Colors.blue,*/
                  value: isselected,
                  onChanged: (valuesecond){
                    setState(() {
                      isselected=valuesecond;
                    });
                  },
                ),
              ],
            ),
            /*const SizedBox(height: 20,),
            Text('Distance in meter : $meter',style: const TextStyle(color: Colors.black,fontSize: 16),),*/
            const SizedBox(height: 40),
            ElevatedButton(onPressed: () async{
              Position position = await _getGeoLocationPosition();
              location ='Lat: ${position.latitude} , Long: ${position.longitude}';
              GetAddressFromLatLong(position);
              if(isselected==false){
                meter=distance(LatLng(lat1, long1),LatLng(position.latitude, position.longitude));
                if(meter<=50)
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
                km=0;
                meter=0;
              }
            }, child:  const Text('Get Location')),
          ],
        ),
      ),
    );
  }
}