// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentSub;
  final _sharedFiles = [];

  @override
  void initState() {
    super.initState();

    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.getMediaStream().listen((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);

        debugPrint(_sharedFiles.map((f) => f.toMap()).toString());
      });
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.getInitialMedia().then((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        debugPrint(_sharedFiles.map((f) => f.toMap()).toString());

        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.reset();
      });
    });
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyleBold = TextStyle(fontWeight: FontWeight.bold);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: _sharedFiles.isNotEmpty
                ? [
                    const Text("Shared files:", style: textStyleBold),
                    Text("path=>>> ${_sharedFiles.first.path}"),
                    Text("message=>>> ${_sharedFiles.first.message}"),
                    Text("mimetype=>>> ${_sharedFiles.first.mimeType}"),
                    Text("thubnail=>>> ${_sharedFiles.first.thumbnail}"),
                    Text("type=>>> ${_sharedFiles.first.type}"),
                    Text("duration=>>> ${_sharedFiles.first.duration}"),
                  ]
                : [
                    const Text("Shared files:", style: textStyleBold),
                  ],
          ),
        ),
      ),
    );
  }
}
