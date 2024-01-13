import 'loader.dart';

abstract class BaseAction {
  final Loader loader;

  BaseAction(this.loader);

  Future<void> performCall(
    Future<void> Function() call, {
    Future<void> Function()? navigationCall,
  }) async {
    loader.show();
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await call();
    } catch (e) {
      loader.hide();
      // ignore: avoid_print
      print(e);
    }

    loader.hide();
    if (navigationCall != null) {
      await navigationCall();
    }
  }
}
