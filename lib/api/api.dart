import 'package:dio/dio.dart';
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

  static sendMessage(String message) {
    var data = {'content': message};
    return RequestManager.post('/chat-room/send', data: data);
  }

  static sendRedPacket(
      {String type = 'random', int money = 32, int count = 2, String msg = '摸鱼者，事竟成！', List? recivers}) {
    String reciverStr = '[]';
    if (recivers != null && recivers.isNotEmpty) {
      reciverStr = '[';
      for (int i = 0; i < recivers.length; i++) {
        reciverStr += recivers[i] + ',';
      }
      // reciverStr = reciverStr.substring(reciverStr.length - 2, 1);
      reciverStr += ']';
      reciverStr.replaceAll(',]', ']');
    }
    var data = {
      'content':
          '[redpacket]{\\"type\\":\\"$type\\",\\"money\\":\\"$money\\",\\"count\\":\\"$count\\",\\"msg\\":\\"$msg\\",\\"recivers\\":$reciverStr}[/redpacket]'
    };
    return RequestManager.post('/chat-room/send', data: data);
  }

  static openRedPack(String oId) {
    var data = {'oId': oId};
    return RequestManager.post('/chat-room/red-packet/open', data: data);
  }

  static upload(List files) async {
    var fileList = [];
    for (var i = 0; i < files.length; i++) {
      var image = await MultipartFile.fromFile(
        files[i].path,
        filename: files[i].name,
      );
      fileList.add(image);
    }
    FormData formData = FormData.fromMap({"file[]": fileList});
    return RequestManager.post('/upload', data: formData, contentType: 'multipart/form-data');
  }

  static getFacePack() {
    var data = {'gameId': 'emojis'};
    return RequestManager.post('/api/cloud/get', data: data);
  }

  static getUserFacePack() {
    var data = {};
    return RequestManager.post('/users/emotions', data: data);
  }
}
