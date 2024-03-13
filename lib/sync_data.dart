import 'dart:async';
import 'dart:isolate';

Future<void> initSyncData() async {
  await Isolate.spawn(_syncData, null);
}

void _syncData(message) async {
  Timer.periodic(const Duration(seconds: 5), (timer) {
    print('Data synchronization completed++++++++++');
  });
}
