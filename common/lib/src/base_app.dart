import 'package:events2/events2.dart';

abstract class BaseApp {
  EventEmitter events = EventEmitter();

  Future<void> dispose() async {
    events.emit('dispose');
  }
}
