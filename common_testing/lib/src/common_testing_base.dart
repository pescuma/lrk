import 'package:fake_async/fake_async.dart';
import 'package:lrk_common/common.dart';

void Function() fake(void Function(FakeTime) body) {
  return () {
    fakeAsync((async) {
      var clock = FakeTime._(async);

      body(clock);
    }, initialTime: DateTime(0, 1, 1, 0, 0, 0, 0, 0));
  };
}

class FakeTime {
  final FakeAsync _async;

  FakeTime._(this._async);

  Clock clock = Clock();

  DateTime get now => clock.now();

  set now(DateTime now) {
    elapse(now.difference(clock.now()));
  }

  void elapse(Duration duration) {
    _async.flushMicrotasks();

    _async.elapse(duration);

    _async.flushMicrotasks();
  }

  T await<T>(Future<T> x) {
    late T result;

    x.then((v) {
      result = v;
    });

    _async.flushMicrotasks();

    return result;
  }
}
