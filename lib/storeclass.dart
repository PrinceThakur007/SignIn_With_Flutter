import 'package:login_user/GitHubUsersModel.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

part 'storeclass.g.dart';

class StoreClass = Myclass with _$StoreClass;

abstract class Myclass with Store {
  @observable
  bool isLoading = false;

  @observable
  List<GitHubUsersModel> listOfUsers;

  @action
  void changeLoading() {
    isLoading = !isLoading;
  }

  @action
  Future<List<GitHubUsersModel>> _getUsers() async {
    var respond = await http.get("https://api.github.com/users");

    if (respond.statusCode == 200) {
      return gitHubUsersModelFromJson(respond.body);
    } else {
      return null;
    }
  }

  List<GitHubUsersModel> getdata()
  {
    return listOfUsers= _getUsers() as List<GitHubUsersModel>;
  }
}
