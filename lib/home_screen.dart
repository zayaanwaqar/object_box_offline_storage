import 'dart:async';
import 'package:object_box_practice/waitlist_emails/waitlist_emails_model.dart';
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
      'https://takatari-cleanup.bubbleapps.io/version-test/api/1.1/wf/create_email_copy';

  final TextEditingController controller = TextEditingController();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // int dataCount = objectBox.getData()?.length ?? 0;
  List<Results> waitListEmails = [];

  @override
  initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<List<Results>> fetchData() async {
    const String endpoint =
        'https://takatari-cleanup.bubbleapps.io/version-test/api/1.1/obj/Test';

    try {
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        objectBox.deleteData(); //
        waitListEmails.clear();
        final data = json.decode(response.body);
        var allRecord = data["response"]["results"];
        for (Map<String, dynamic> index in allRecord) {
          waitListEmails.add(Results.fromJson(index));
        }
        // dataCount = dataCount + waitListEmails.length;
        for (int i = 0; i < waitListEmails.length; i++) {
          objectBox.addUser(
            UserModelObject(
              internalId: 0,
              userId: 1,
              email: waitListEmails[i].email,
              mobile: '',
              name: 'T',
              roll: '',
            ),
          );
        }
      }
      return waitListEmails;
    } catch (e) {
      print('Exception: $e');
      return waitListEmails;
    }
  }

  Future<void> pushData(int i) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': objectBox.getData()![i].email.toString(),
      }),
    );

    if (response.statusCode == 200) {
      if (prefs.getString('saveData') == 'True') {
        await prefs.setString('addData', 'False');
        objectBox.deleteData();
        waitListEmails.clear();
        await fetchData();
        setState(() {});
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    if ((result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile) &&
        prefs.getString('firstTime') == 'True') {
      await fetchData();
      await prefs.setString('firstTime', 'True');
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    prefs.setString('saveData', 'False');
    final String? action = prefs.getString('addData');
    if ((result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile) &&
        action == 'True') {
      for (int i = 0; i < objectBox.getData()!.length; i++) {
        if (i == objectBox.getData()!.length - 1) {
          prefs.setString('saveData', 'True');
        }
        if (objectBox.getData()![i].name == 'F') {
          await pushData(i);
        }
      }
      objectBox.deleteData();
      waitListEmails.clear();
      await fetchData();
    }
    setState(() {
      _connectionStatus = result;
    });
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
                          objectBox.getData()![index].email.toString(),
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
                  itemCount: objectBox.getData()!.length,
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
                      email: controller.text,
                      mobile: '03314841937',
                      name: 'F',
                      roll: '123',
                    ),
                  );

                  await prefs.setString('addData', 'True');
                  final String? action = prefs.getString('addData');
                  if ((_connectionStatus == ConnectivityResult.wifi ||
                          _connectionStatus == ConnectivityResult.mobile) &&
                      action == 'True') {
                    for (int i = 0; i < objectBox.getData()!.length; i++) {
                      if (objectBox.getData()![i].name == 'F') {
                        await pushData(i);
                      }
                    }
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
