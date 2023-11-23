import 'dart:io';
import 'dart:isolate';

import 'package:dukkachallenge/page_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

void main() {
  runApp(
    const MaterialApp(
      home: SecondPage(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final receivePort = ReceivePort();
  final isolates = <Isolate>[];

  @override
  void initState() {
    super.initState();
    listenToMessageFromPorts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Dowload image"),
          ElevatedButton(
            onPressed: _handleDownloadImage,
            child: const Text("Download image"),
          )
        ],
      ),
    );
  }

  void _handleDownloadImage() async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    for (var i = 0; i < 5; i++) {
      final isolate = await Isolate.spawn(_downloadImage, receivePort.sendPort);
      isolates.add(isolate);
    }
  }

  void listenToMessageFromPorts() {
    receivePort.listen((message) {
      print(message);
    });
  }
}

Future<void> _downloadImage(SendPort sendPort) async {
  try {
    final http.Response response =
        await http.get(Uri.parse("https://picsum.photos/200"));
    final dir = await getTemporaryDirectory();
    var filename = '${dir.path}/image.png';
    final file = File(filename);
    await file.writeAsBytes(response.bodyBytes);
    sendPort.send(file);
  } catch (e) {
    print(e);
    print("Their is an errror oo");
  }
}
