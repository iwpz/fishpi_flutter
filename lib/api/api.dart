import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fishpi_flutter/manager/request_manager.dart';

class Api {
  static getKey({required String nameOrEmail, required String userPassword, String? twoStepCode}) {
    var data = {
      'nameOrEmail': nameOrEmail,
      'userPassword': userPassword,
      'mfaCode': twoStepCode,
    };
    return RequestManager.post('/api/getKey', data: data);
  }

  static register({required String userName, required String phoneNumber, required captcha}) {
    var data = {
      'userName': userName,
      'userPhone': phoneNumber,
      'captcha': captcha,
    };
    return RequestManager.post('/register', data: data);
  }

  static finishRegister({
    required int userAppRole,
    required String userPassword,
    required String userId,
  }) {
    var data = {
      'userAppRole': userAppRole,
      'userPassword': userPassword,
      'userId': userId,
      // 'r': 'iwpz',
    };
    RequestManager.post('/register2?r=iwpz', data: data);
  }

  static checkVerifyCode(String code) {
    return RequestManager.get('/verify?code=$code');
  }

  static getChatHistoryMessage({int page = 1}) {
    return RequestManager.get('/chat-room/more', params: {'page': page});
  }

  static getUserInfo() {
    return RequestManager.get('/api/user');
  }

  static getOtherUserInfo(String userName) {
    return RequestManager.get('/user/$userName');
  }

  static sendMessage(String message) {
    var data = {'content': message};
    return RequestManager.post('/chat-room/send', data: data);
  }

  static revokeMessage(String oId) {
    return RequestManager.delete('/chat-room/revoke/$oId');
  }

  static reportMessage({
    required String reportDataId,
    int reportDataType = 3,
    int reportType = 49,
    String reportMemo = '',
  }) {
    var data = {
      'reportDataId': reportDataId,
      'reportDataType': reportDataType,
      'reportType': reportType,
      'reportMemo': reportMemo,
    };
    return RequestManager.post(
      '/report',
      data: data,
      contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
    );
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

  static addFacePack(List urls) {
    var data = {
      'gameId': 'emojis',
      'data': json.encode(urls),
    };
    return RequestManager.post('/api/cloud/sync', data: data);
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

  static getRecentPosts({int page = 1}) {
    Map<String, dynamic> params = {'p': page};
    return RequestManager.get('/api/articles/recent', params: params);
  }

  static getHotPosts({int page = 1}) {
    Map<String, dynamic> params = {'p': page};
    return RequestManager.get('/api/articles/recent/hot', params: params);
  }

  static getGoodPosts({int page = 1}) {
    Map<String, dynamic> params = {'p': page};
    return RequestManager.get('/api/articles/recent/good', params: params);
  }

  static getRecentReplyPosts({int page = 1}) {
    Map<String, dynamic> params = {'p': page};
    return RequestManager.get('/api/articles/recent/reply', params: params);
  }

  static getPostInfo(String oId) {
    return RequestManager.get('/api/article/$oId');
  }

  static sendPost({
    required String title,
    required String content,
    required String tags,
    bool? commentable = true,
    bool? notifyFollowers = true,
    int type = 0,
    bool? showInList = true,
    String? rewardContent,
    int? rewardPoint,
    bool? anonymous = false,
  }) {
    var data = {
      "articleTitle": title,
      "articleContent": content,
      "articleTags": tags,
      "articleCommentable": commentable,
      "articleNotifyFollowers": notifyFollowers,
      "articleType": type,
      "articleShowInList": showInList == true ? 1 : 0,
      "articleAnonymous": anonymous,
    };
    if (rewardContent != null && rewardContent.isNotEmpty && rewardPoint != null && rewardPoint > 0) {
      data["articleRewardContent"] = rewardContent;
      data["articleRewardPoint"] = rewardPoint.toString();
    }
    return RequestManager.post('/article', data: data);
  }

  static getPrivateMessage() {
    return RequestManager.get('/chat/get-list');
  }

  static markPMReaded(String mapId) {
    var params = {'mapId': mapId};
    return RequestManager.get('/idle-talk/seek', params: params);
  }

  static sendPM({
    required String userName,
    required String title,
    required String content,
  }) {
    var data = {
      'userName': userName,
      'theme': title,
      'content': content,
    };
    return RequestManager.post('/idle-talk/send', data: data);
  }

  static revokePM(String mapId) {
    var params = {'mapId': mapId};
    return RequestManager.get('/idle-talk/revoke', params: params);
  }

  static getCaptcha() {
    return '/captcha';
  }

  static getLiveness() {
    return RequestManager.get('/user/liveness');
  }
}
