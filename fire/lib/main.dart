import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class SensorData {
  final int gas;
  final double temperature;
  final int flame;

  const SensorData(this.gas, this.temperature, this.flame);

  factory SensorData.fromJson(Map<dynamic, dynamic> json) {
    return SensorData(
      json['gas'] as int,
      json['temperature'] as double,
      json['flame'] as int,
    );
  }
}

bool isFirebaseInitialized = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!isFirebaseInitialized) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        appId: '1:1019941117037:web:dfb5b6f0d5d21d7f423364',
        apiKey: 'AIzaSyDJXY2uDV4owZ_2UpZla98L-eB_-lL3bhg',
        projectId: 'fire-system-491cd',
        messagingSenderId: '1019941117037',
        databaseURL: 'https://fire-system-491cd-default-rtdb.firebaseio.com',
      ),
    );
    isFirebaseInitialized = true;
  }

  runApp(const MaterialApp(
    title: 'Sensor App',
    home: SensorApp(),
  ));
}

class SensorApp extends StatefulWidget {
  const SensorApp({Key? key}) : super(key: key);

  @override
  SensorAppState createState() => SensorAppState();
}

class SensorAppState extends State<SensorApp> {
  final databaseReference = FirebaseDatabase.instance.ref();

  int gasValue = 0;
  double temperatureValue = 0.0;
  int flameValue = 0;

  @override
  void initState() {
    super.initState();
    // Start listening for changes in the sensor data
    databaseReference.child('sensors').onValue.listen((event) {
      setState(() {
        final sensorData =
            SensorData.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
        gasValue = sensorData.gas;
        temperatureValue = sensorData.temperature;
        flameValue = sensorData.flame;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gas Value: $gasValue'),
            Text('Temperature Value: $temperatureValue'),
            Text('Flame Value: $flameValue'),
          ],
        ),
      ),
    );
  }
}
