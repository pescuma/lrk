import 'dart:async';

abstract class Disposable {
  Future<void> dispose();
}

class Disposer implements Disposable {
  var entries = <Function>[];

  T register<T>(T obj, {bool ignoreIfCantDispose = false}) {
    if (obj is Disposable) {
      entries.add(obj.dispose);
    } else if (obj is Function) {
      entries.add(obj);
    } else if (obj is Timer) {
      entries.add(obj.cancel);
    } else if (!ignoreIfCantDispose) {
      throw Exception('Unknown object type');
    }
    return obj;
  }

  @override
  Future<void> dispose() async {
    var ds = entries.reversed;
    entries = [];

    await Future.wait(ds.map((e) async => await e()));
  }
}
