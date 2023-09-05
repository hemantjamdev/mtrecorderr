import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

class FloatingRecord {
  static SendPort? homePort;
  static const String kPortNameHome = 'UI';

  static final receivePort = ReceivePort();

  static void initFloating(Function(dynamic) callback) {
    if(!Platform.isAndroid)return;
    if (homePort != null) return;
    IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      kPortNameHome,
    );
    receivePort.listen((message) {
      callback(message);
    });
    //_receivePort.listen(callback);
  }

/*static dispose() {
    _receivePort.close();
  }*/
}
