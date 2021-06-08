import 'dart:convert';

import 'package:channel_io_flutter/channel_io_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String content = '';
  TextEditingController contentInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    contentInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel IO Flutter Plugin Test'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () async {
                  content = '''
{
  "pluginKey": "",
  "email": "",
  "memberId": "",
  "name": "",
  "memberHash": "",
  "mobileNumber": "",
  "trackDefaultEvent": false,
  "hidePopup": false,
  "language": "english"
}
                            ''';
                  _showInputDialog(
                    'boot payload',
                    () async {
                      try {
                        Map args = json.decode(content);
                        final result = await ChannelIoFlutter.boot(
                          pluginKey: args['pluginKey'],
                          memberId: args['memberId'],
                          email: args['email'],
                          name: args['name'],
                          memberHash: args['memberHash'],
                          mobileNumber: args['mobileNumber'],
                          trackDefaultEvent: args['trackDefaultEvent'],
                          hidePopup: args['hidePopup'],
                          language: args['language'],
                        );

                        _showMessageDialog('Result: $result');
                      } on PlatformException catch (error) {
                        _showMessageDialog(
                            'PlatformException: ${error.message}');
                      } catch (err) {
                        _showMessageDialog(err.message);
                      }
                    },
                  );
                },
                child: Text('boot'),
              ),
              RaisedButton(
                onPressed: () async {
                  try {
                    final result = await ChannelIoFlutter.shutdown();

                    _showMessageDialog('Result: $result');
                  } on PlatformException catch (error) {
                    _showMessageDialog('PlatformException: ${error.message}');
                  } catch (err) {
                    _showMessageDialog(err.message);
                  }
                },
                child: Text('shutdown'),
              ),
              RaisedButton(
                onPressed: () async {
                  try {
                    final result = await ChannelIoFlutter.showMessenger();

                    _showMessageDialog('Result: $result');
                  } on PlatformException catch (error) {
                    _showMessageDialog('PlatformException: ${error.message}');
                  } catch (err) {
                    _showMessageDialog(err.message);
                  }
                },
                child: Text('showMessenger'),
              ),
              RaisedButton(
                onPressed: () async {
                  try {
                    final result = await ChannelIoFlutter.isBooted();

                    if (result) {
                      _showMessageDialog('isBooted success');
                    } else {
                      _showMessageDialog('isBooted fail');
                    }
                  } on PlatformException catch (error) {
                    _showMessageDialog('PlatformException: ${error.message}');
                  } catch (err) {
                    _showMessageDialog(err.message);
                  }
                },
                child: Text('isBooted'),
              ),
              RaisedButton(
                onPressed: () async {
                  content = '''
{
  "flag": true
}
                  ''';

                  _showInputDialog(
                    'initPushToken payload',
                    () async {
                      Map args = json.decode(content);

                      try {
                        final result = await ChannelIoFlutter.setDebugMode(
                            flag: args['flag']);

                        _showMessageDialog('Result: $result');
                      } on PlatformException catch (error) {
                        _showMessageDialog(
                            'PlatformException: ${error.message}');
                      } catch (err) {
                        _showMessageDialog(err.message);
                      }
                    },
                  );
                },
                child: Text('setDebugMode'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            FlatButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _showInputDialog(String title, Function onClick) {
    contentInputController.text = content;
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0XFF1A1A1A),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: contentInputController,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Color(0XFF9E9E9E),
                    ),
                  ),
                  textInputAction: TextInputAction.newline,
                  autocorrect: false,
                  enableSuggestions: false,
                  onChanged: (text) {
                    content = text;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xFF00A0E9),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF00A0E9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFF00A0E9),
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (onClick != null) {
                              onClick();
                              content = '';
                            }
                          },
                          child: Text(
                            'OK',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
