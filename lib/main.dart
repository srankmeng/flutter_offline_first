import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './common_widgets/dog_builder.dart';
import './models/dog.dart';
import './connection_status.dart';
import './db.dart';

final DBProvider _db = DBProvider();

void main() {
  runApp(const MyApp());
  connectionStatus.initialize();
  _syncData();
}

void _syncData() async {
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (connectionStatus.hasConnection) {
      var dogs = await _db.dogs('all');
      for (var item in dogs) {
        try {
          final response =
              await http.put(Uri.parse('http://10.0.2.2:8001/api/v1/dog'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({
                    "id": item.id,
                    "name": item.name,
                    "age": item.age,
                    "version": item.version,
                    "status": item.status,
                  }));
          if (response.statusCode != 200) {
            print('Error updating data on server: ${response.statusCode}');
          }
        } catch (error) {
          print('Error during synchronization: $error');
        }
      }
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Dog>> _getDogs() async {
    return await _db.dogs('active');
  }

  Future<void> _addDog() async {
    var data = Dog(
      name: 'Doggie',
      age: Random().nextInt(18),
      version: 1,
      status: '',
    );
    await _db.insertDog(data);
    setState(() {});
  }

  Future<void> _editDog(Dog dog) async {
    var data = Dog(
      id: dog.id,
      name: '${dog.name} E',
      age: dog.age,
      version: dog.version + 1,
      status: dog.status,
    );
    await _db.updateDog(data);
    setState(() {});
  }

  Future<void> _deleteDog(Dog dog) async {
    var data = Dog(
      id: dog.id,
      name: dog.name,
      age: dog.age,
      version: dog.version + 1,
      status: 'deleted',
    );
    await _db.updateDog(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DogBuilder(
                    dogs: _getDogs(),
                    onEdit: _editDog,
                    onDelete: _deleteDog,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDog,
        tooltip: 'Add Dog',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
