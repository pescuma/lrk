import 'disposer.dart';
import 'event_emitter.dart';

abstract class BaseApp implements Disposable {
  var events = EventEmitter();

  @override
  Future<void> dispose() async {}
}
