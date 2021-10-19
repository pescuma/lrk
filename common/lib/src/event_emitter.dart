import 'dart:async';
import 'dart:core';

// Based on https://github.com/cloudwebrtc/dart-events
class EventEmitter {
  Map<String, List<Function>> _events = <String, List<Function>>{};
  Map<String, List<Function>> _eventsOnce = <String, List<Function>>{};

  /// This function binds the `handler` as a listener to the `event`
  ///
  /// @param String event     - The event to add the handler to
  /// @param Function handler - The handler to bind to the event
  /// @return void
  void on(String event, Function handler) {
    _events.putIfAbsent(event, () => <Function>[]);
    _events[event]!.add(handler);
  }

  /// This function binds the `handler` as a listener to the first
  /// occurrence of the `event`. When `handler` is called once,
  /// it is removed.
  ///
  /// @param String event     - The event to add the handler to
  /// @param Function handler - The handler to bind to the event
  /// @return void
  void once(String event, Function handler) {
    _eventsOnce.putIfAbsent(event, () => <Function>[]);
    _eventsOnce[event]!.add(handler);
  }

  /// This function attempts to unbind the `handler` from the `event`
  ///
  /// @param String event     - The event to remove the handler from
  /// @param Function handler - The handler to remove
  /// @return void
  void remove(String event, Function handler) {
    _events[event]?.removeWhere((item) => item == handler);
    _eventsOnce[event]?.removeWhere((item) => item == handler);
  }

  /// This function triggers all the handlers currently listening
  /// to `event` and passes them `data`.
  ///
  /// @param String event - The event to trigger
  /// @param [args] - The variable numbers of arguments to send to each handler
  /// @return void
  Future<void> emit(String event, [arg0, arg1, arg2, arg3, arg4, arg5]) async {
    var execute = <Function>[];
    execute.addAll(_events[event] ?? []);
    execute.addAll(_eventsOnce.remove(event) ?? []);

    await Future.wait(execute.map((f) => _call(f, arg0, arg1, arg2, arg3, arg4, arg5)));
  }

  Future<void> _call(Function func, [arg0, arg1, arg2, arg3, arg4, arg5]) async {
    String arguments = func.runtimeType.toString().split(' => ')[0];
    if (arguments.length > 3) {
      String args = arguments.substring(1, arguments.length - 1);
      args = args.replaceAll(RegExp("<(.*)>"), "");
      int argc = args.split(', ').length;
      switch (argc) {
        case 1:
          await func(arg0);
          break;
        case 2:
          await func(arg0, arg1);
          break;
        case 3:
          await func(arg0, arg1, arg2);
          break;
        case 4:
          await func(arg0, arg1, arg2, arg3);
          break;
        case 5:
          await func(arg0, arg1, arg2, arg3, arg4);
          break;
        case 6:
          await func(arg0, arg1, arg2, arg3, arg4, arg5);
          break;
      }
    } else {
      await func();
    }
  }

  /// This function attempts to unbind all the `handler` from the `event`
  ///
  /// @param String event     - The event to remove the handler from. If null, remove all handlers.
  /// @return void
  void clearListeners([String? event]) {
    if (event != null) {
      _events.remove(event);
      _eventsOnce.remove(event);
    } else {
      _events = <String, List<Function>>{};
      _eventsOnce = <String, List<Function>>{};
    }
  }
}
