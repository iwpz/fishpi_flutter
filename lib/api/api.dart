import 'dart:convert';

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

  static revokeMessage(String oId) {
    return RequestManager.delete('/chat-room/revoke/$oId');
  }

  static sendRedPacket({
    String type = 'random',
    int money = 32,
    int count = 2,
    String msg = '摸鱼者，事竟成！',
    List? recivers,
    int gesture = -1,
  }) {
    var redpackData = {
      "type": type,
      "money": money,
      "count": count,
      "msg": msg,
    };
    if (type == 'specify' && recivers != null && recivers.isNotEmpty) {
      print(recivers);
      redpackData['recivers'] = recivers;
    }
    if (gesture != -1) {
      redpackData['gesture'] = gesture;
    }
    var data = {'content': '[redpacket]' + json.encode(redpackData) + '[/redpacket]'};
    return RequestManager.post('/chat-room/send', data: data);
  }

  static openRedPack(String oId, {int gesture = -1}) {
    var data = {'oId': oId};
    if (gesture != -1) {
      data['gesture'] = gesture.toString();
    }
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

  static getWindMoonList({int page = 1, int pageSize = 20}) {
    Map<String, dynamic> params = {
      "p": page,
      "size": pageSize,
    };
    return RequestManager.get('/api/breezemoons', params: params);
  }

  static sendWindMoon(String content) {
    var data = {'breezemoonContent': content};
    return RequestManager.post('/breezemoon', data: data);
  }
}
