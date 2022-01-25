import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'Welcome_Page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppScreen extends StatefulWidget {
  static const String id = "appscreen";
  final double lat;
  final double long;
  final String Id;
  AppScreen(this.lat, this.long, this.Id);

  @override
  State<AppScreen> createState() => AppScreenState();
}

class AppScreenState extends State<AppScreen> {
  late double lat = widget.lat;
  late double long = widget.long;
  late BitmapDescriptor myIcon;
  late String id = widget.Id;
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  bool flag = false;
  bool loading = false;
  int station = 0;
  bool variable = false;
  String name = '';
  bool status=false;
  CollectionReference bikeDb1 =
      FirebaseFirestore.instance.collection('Station/1/bike');
  CollectionReference bikeDb2 =
      FirebaseFirestore.instance.collection('Station/2/bike');
  List model = [];
  List price = [];
  List range = [];
  List battery = [];
  List speed = [];
  List avail = [];

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _yourLocationMarker() {
    _markers.add(Marker(
      markerId: MarkerId('Current Position'),
      position: LatLng(lat, long),
      infoWindow: InfoWindow(
        title: 'YOUR LOCATION',
      ),
      icon: BitmapDescriptor.defaultMarker,
      onTap: () {
        setState(() {
          flag = false;
        });
      },
    ));
    _markers.add(Marker(
      markerId: MarkerId('station1'),
      position: LatLng(28.652663, 77.353912),
      infoWindow: InfoWindow(
        title: 'Bike Station 1',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      onTap: () async {
        setState(() {
          loading=true;
        });
        List val1 = await popupData1(bikeDb1);
        List val2 = await popupData2(bikeDb1);
        List val3 = await popupData3(bikeDb1);
        List val4 = await popupData4(bikeDb1);
        List val5 = await popupData5(bikeDb1);
        List val6 = await popupData6(bikeDb1);
        setState(() {
          station = 1;

          battery = val1;
          model = val2;
          price = val3;
          range = val4;
          speed = val5;
          avail = val6;
          loading=false;
          flag = true;
          print(flag);
        });
      },
    ));
    _markers.add(Marker(
      markerId: MarkerId('station2'),
      position: LatLng(28.649983, 77.355653),
      infoWindow: InfoWindow(
        title: 'Bike Station 2',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      onTap: () async {
        setState(() {
          loading=true;
        });

        List val1 = await popupData1(bikeDb2);
        List val2 = await popupData2(bikeDb2);
        List val3 = await popupData3(bikeDb2);
        List val4 = await popupData4(bikeDb2);
        List val5 = await popupData5(bikeDb2);
        List val6 = await popupData6(bikeDb2);

        setState(() {
          station = 2;

          battery = val1;
          model = val2;
          price = val3;
          range = val4;
          speed = val5;
          avail = val6;
          loading=false;
          flag = true;
        });
      },
    ));
  }

  Future<bool?> _onBackPressed(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Are you sure you want to exit the app')),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('NO')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        WelcomePage.id, (Route<dynamic> route) => false);
                  },
                  child: Text('YES')),
            ],
          );
        });
  }

  // Future activateListener() async {
  //   DocumentReference use = FirebaseFirestore.instance.doc('Station/2/bike/X');
  //   DocumentSnapshot data = await use.get();
  //   Map<String, dynamic> data1 = data.data() as Map<String, dynamic>;
  //   print('jade');
  //   print(data1);
  // }
  Future<void> username() async {
    DocumentReference user = FirebaseFirestore.instance.doc('users/$id');
    DocumentSnapshot data = await user.get();
    Map<String, dynamic> data1 = data.data()! as Map<String, dynamic>;
    print(data1);
    setState(() {
      name=data1['Name'];
      status=data1['Status'];
    });
  }

  Future popupData1(bikeDb) async {
    List<String> battery = [];
    await bikeDb.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        battery.add(doc['battery']);
      });
    });
    return battery;
  }

  Future popupData2(bikeDb) async {
    List<String> model = [];
    await bikeDb.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        model.add(doc['model']);
      });
    });
    return model;
  }

  Future popupData3(bikeDb) async {
    List<int> price = [];
    await bikeDb.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        price.add(doc['price']);
      });
    });
    return price;
  }

  Future popupData4(bikeDb) async {
    List<int> range = [];
    await bikeDb.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        range.add(doc['range']);
      });
    });
    return range;
  }

  Future popupData5(bikeDb) async {
    List<int> speed = [];
    await bikeDb.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        speed.add(doc['speed']);
      });
    });
    return speed;
  }

  Future popupData6(bikeDb) async {
    List<int> avail = [];
    await bikeDb.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        avail.add(doc['num']);
      });
    });
    print(avail);
    return avail;
  }

  @override
  void initState() {
    super.initState();
    _yourLocationMarker();
    //activateListener();
    username();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (flag == true) {
          setState(() {
            flag = false;
          });
          return false;
        } else {
          final shouldpop = await _onBackPressed(context);
          return shouldpop ?? false;
        }
      },
      child: SafeArea(
        child: Scaffold(
          drawer: Drawer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,',
                    style: GoogleFonts.unicaOne(
                      fontSize: 60,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    name,
                    style: GoogleFonts.unicaOne(
                      fontSize: 60,
                      fontWeight: FontWeight.w400,
                      color: Colors.greenAccent,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(Icons.circle_notifications,color: status==true?Colors.green:Colors.red),
                      SizedBox(
                        width: 10,
                      ),
                      status==true?Text('Trip active',style: TextStyle(color: Colors.green,fontSize: 17)):Text('Trip inactive',style: TextStyle(color: Colors.red,fontSize: 17)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: Text(
              'Green Pedal',
              style: GoogleFonts.unicaOne(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.teal[100],
          ),
          body: loading
              ? Center(child: CircularProgressIndicator())
              :Stack(children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, long),
                zoom: 17.0,
              ),
              mapType: MapType.normal,
              markers: _markers,
            ),
            Visibility(
              visible: flag,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 20, 10, 16),
                  child: Container(
                    height: 350,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 100.0,
                      ),
                      itemBuilder: (BuildContext ctx, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(1),
                                spreadRadius: -30,
                                blurRadius: 50,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/model${index + 1}.png'),
                                        fit: BoxFit.fitHeight),
                                  ),
                                ),
                              )),
                              Padding(
                                padding: const EdgeInsets.only(left: 32.0),
                                child: Container(
                                  child: Text(
                                    //update
                                    'Model ${model[index]}',
                                    style: GoogleFonts.unicaOne(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 32.0, top: 12.0),
                                child: Container(
                                  child: Text(
                                    //update
                                    '${speed[index]} km/hr',
                                    style: GoogleFonts.unicaOne(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                thickness: 3,
                                indent: 50,
                                endIndent: 50,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        '    Range',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '  Battery',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Availability',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      //update
                                      Text('${range[index]}'),
                                      Text('${battery[index]}%'),
                                      Text('${avail[index]}')
                                    ]),
                              ),
                              Container(
                                width: double.infinity,
                                color: Colors.teal[100],
                                child: TextButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new Scanner(
                                                      id,
                                                      model[index],
                                                      station,
                                                      avail[index],
                                                      variable))).then((_) {
                                        //rent !=null
                                        //?
                                        setState(() {
                                          print('rent');
                                          variable = !variable;
                                          status=!status;
                                          flag = false;
                                        });
                                        // : setState(() {
                                        //   print('maggie');
                                        //   print(rent);
                                        //     flag = false;
                                        //   });
                                      });
                                    },
                                    child: Text(
                                      variable
                                          ? 'RETURN BIKE'
                                          : 'SELECT BIKE at ₹${price[index]}/hr',
                                      style: GoogleFonts.unicaOne(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      itemCount: 2,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
