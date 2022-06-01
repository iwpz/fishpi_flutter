import 'package:fishpi_flutter/tools/sp_tool.dart';

class BlackListManager {
  factory BlackListManager() => _sharedInstance();
  List<String> blackList = List.empty(growable: true);
  static final BlackListManager _instance = BlackListManager._();
  BlackListManager._();

  static BlackListManager _sharedInstance() {
    return _instance;
  }

  Future<bool> init() async {
    var list = await SPTool().getStorage('blacklist');
    if (list != null) {
      list.forEach((e) {
        blackList.add(e);
      });
    }
    return true;
  }

  void addToBlackList(String username) {
    if (blackList.contains(username)) {
    } else {
      blackList.add(username);
      SPTool().setStorage('blacklist', blackList);
    }
  }

  bool isInBlackList(String username) {
    return blackList.contains(username);
  }

  void clearBlackList() {
    blackList.clear();
    SPTool().removeStorage('blacklist');
  }

  void removeFromBlackList(String username) {
    blackList.removeWhere((element) => element == username);
    SPTool().removeStorage('blacklist');
    SPTool().setStorage('blacklist', blackList);
  }
}
