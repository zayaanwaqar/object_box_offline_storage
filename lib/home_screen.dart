import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:object_box_practice/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'object_box/user_model_object.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiUrl =
      'https://mymindguide.bubbleapps.io/version-test/api/1.1/wf/create_email';
  late Map<String, dynamic> data;
  final TextEditingController controller = TextEditingController();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late SharedPreferences prefs;
  int i = 0;

  // final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  @override
  initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        // Add any additional headers if required
      },
      body: jsonEncode({
        'email': objectBox.getData()![i].name.toString(),
      }),
    );

    if (response.statusCode == 200) {
      await prefs.setString('addData', 'False');
      // controller.clear();
      // objectBox.deleteData();
      // If server returns an OK response, parse the JSON
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    prefs = await SharedPreferences.getInstance();
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    final String? action = prefs.getString('addData');
    if ((result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile) &&
        action == 'True') {
      for (i = 0; i < objectBox.getData()!.length; i++) {
        await fetchData();
      }objectBox.deleteData();
      i = 0;
    }
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> functionality() async {
    objectBox.addUser(
      UserModelObject(
        internalId: 0,
        userId: 1,
        email: 'zayaanwaqar@gmail.com',
        mobile: '03314841937',
        name: 'Connection Restored',
        roll: '123',
      ),
    );
    await prefs.setString('addData', 'False');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          objectBox.getData()![index].name.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 10,
                    );
                  },
                  itemCount: objectBox.getData()?.length ?? 0,
                ),
              ),
            ),
            Text('Connection Status: ${_connectionStatus.toString()}'),
            TextField(
              obscureText: false,
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  objectBox.addUser(
                    UserModelObject(
                      internalId: 0,
                      userId: 1,
                      email: 'zayaanwaqar@gmail.com',
                      mobile: '03314841937',
                      name: controller.text,
                      roll: '123',
                    ),
                  );
                  await prefs.setString('addData', 'True');
                  final String? action = prefs.getString('addData');
                  if ((_connectionStatus == ConnectivityResult.wifi ||
                          _connectionStatus == ConnectivityResult.mobile) &&
                      action == 'True') {
                    for (i = 0; i < objectBox.getData()!.length; i++) {
                      await fetchData();
                    }objectBox.deleteData();
                    i = 0;
                  }
                  controller.clear();
                  setState(() {});
                },
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
