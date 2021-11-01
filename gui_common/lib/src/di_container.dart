import 'package:klizma/klizma.dart' as klizma;
import 'package:lrk_common/common.dart';

class DIContainer extends klizma.Container {
  final disposer = Disposer();

  @override
  void provide<T extends Object>(klizma.FactoryFun<T> factory,
      {String name = '', bool cached = true}) {
    super.provide((_) => disposer.register(factory(_), ignoreIfCantDispose: true),
        name: name, cached: cached);
  }

  Future<void> disposeCreated() {
    return disposer.dispose();
  }
}
