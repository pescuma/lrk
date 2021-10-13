import 'package:lrk_common/common.dart';
import 'package:test/test.dart';
import 'package:fake_async/fake_async.dart';

void test_c(description, dynamic Function(FakeTime) body, {DateTime? time}) {
  time ??= DateTime(0, 1, 1, 0, 0, 0, 0, 0);

  test(description, () {
    fakeAsync((async) {
      var clock = FakeTime._(async);

      body(clock);
    }, initialTime: time);
  });
}

class FakeTime {
  final FakeAsync _async;

  FakeTime._(this._async);

  Clock clock = Clock();

  DateTime get now => clock.now();

  set now(DateTime now) {
    _async.elapse(now.difference(clock.now()));
  }

  void elapse(Duration duration) {
    _async.elapse(duration);
  }
}
