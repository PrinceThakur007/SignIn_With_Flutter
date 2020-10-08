import 'package:mobx/mobx.dart';

part 'storeclass.g.dart';

class StoreClass = Myclass with _$StoreClass;

abstract class Myclass with Store {
  @observable
  bool isLoading = false;

  @action
  void changeLoading() {
    isLoading = !isLoading;
  }
}
