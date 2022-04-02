import 'package:fishpi_flutter/manager/request_manager.dart';

class Api {
  static getKey({required String nameOrEmail, required String userPassword}) {
    var data = {
      'nameOrEmail': nameOrEmail,
      'userPassword': userPassword,
    };
    return RequestManager.post('/api/getKey', data: data);
  }

  static getChatHistoryMessage({int page = 1}) {
    return RequestManager.get('/chat-room/more', params: {'page': page});
  }

  static getUserInfo() {
    return RequestManager.get('/api/user');
  }
}
