import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fishpi_flutter/config.dart';

class RequestManager {
  // 配置 Dio 实例
  static late BaseOptions _options;
  static String apiKey = '';

  factory RequestManager() => _sharedInstance();
  static RequestManager _instance = RequestManager._();
  RequestManager._();

  static setToken(String token) {
    _options.headers['X-CSRF-TOKEN'] = token;
    _dio.options = _options;
  }

  static init({
    InterceptorSendCallback? onRequest,
    InterceptorSuccessCallback? onResponse,
    InterceptorErrorCallback? onError,
  }) {
    _options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: 20000,
      receiveTimeout: 20000,
      contentType: 'application/json',
      headers: {
        "user-agent": Platform.isIOS
            ? "Mozilla/5.0 (iPhone; CPU iPhone OS 15_3_1 like Mac OS X) FishPiFlutter AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Mobile/15E148 Safari/604.1"
            : "Mozilla/5.0 (Windows NT 10.0; WOW64) FishPiFlutter Android AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36",
      },
    );
    _dio = Dio(_options);
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        if (onRequest != null) {
          onRequest(options, handler);
        } else {
          handler.next(options);
        }
      }, onResponse: (Response response, ResponseInterceptorHandler handler) {
        if (onResponse != null) {
          onResponse(response, handler);
        } else {
          handler.next(response);
        }
      }, onError: (DioError error, ErrorInterceptorHandler handler) {
        if (onError != null) {
          onError(error, handler);
        } else {
          handler.next(error);
        }
      }),
    );
    print('create dio with options');
    print(_options.headers);
  }

  static void updateApiKey(String key) {
    apiKey = key;
  }

  static RequestManager _sharedInstance() {
    return _instance;
  }

  static Dio _dio = Dio(_options);

  static Future<T> _request<T>(String path,
      {required String method, Map? params, data, CancelToken? cancelToken, String contentType = ''}) async {
    if (method == 'post' || method == 'delete' || method == 'put') {
      if (apiKey.isNotEmpty && !path.contains('upload')) {
        if (data != null) {
          data['apiKey'] = apiKey;
        } else {
          data = {'apiKey': apiKey};
        }
      }
      longPrint('data:$data');
    } else {
      if (apiKey.isNotEmpty && !path.contains('upload')) {
        if (params != null) {
          params['apiKey'] = apiKey;
        } else {
          params = {'apiKey': apiKey};
        }
      }
      longPrint('param:$params');
    }
    if (params != null) {
      path = path + '?';
      params.forEach((key, value) {
        path = path += '$key=$value&';
      });
      path = path.substring(0, path.length - 1);
    }

    _options.contentType = contentType;
    print('🚀🚀🚀==========================================================================');
    print('request:');
    print(_options.baseUrl + path);
    print('method:$method');
    print('header:');
    print(_options.headers);
    print('🚀🚀🚀=================================================');
    try {
      Response response =
          await _dio.request(path, data: data, options: Options(method: method), cancelToken: cancelToken);
      print('response url: ${_options.baseUrl + path}');
      if (method == 'post' || method == 'delete' || method == 'put') {
        longPrint('data:$data');
      } else {
        longPrint('param:$params');
      }
      print('----------');
      longPrint(response.toString());
      // print(response);
      print('----------');
      print('🚀🚀🚀==========================================================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // if (response.data['success'] != true) {
          //   return Future.error(response.data['message']);
          // } else {
          if (response.data is Map) {
            return response.data;
          } else {
            return json.decode(response.data.toString());
          }
          // }
        } catch (e) {
          // LogUtil.error(e.toString());
          // print(e);
          Fluttertoast.showToast(msg: '解析响应数据异常');

          return Future.error('解析响应数据异常');
        }
      } else if (response.statusCode == 401) {
        // var loginRes = await MeetingApi.padLogin(params: {'sn': DataManager.sn});
        // if (loginRes['code'] == 0) {
        //   updateToken(loginRes['data']['access_token']);
        // }
        // return _request(path, method: method, data: data, params: params);
        return Future.error('401');
      } else {
        _handleHttpError(response.statusCode!);
        Fluttertoast.showToast(msg: 'HTTP错误');
        return Future.error('HTTP错误');
      }
    } on DioError catch (e) {
      print('dio error:');
      print(e.error);
      print(e.message);
      // LogUtil.error(_dioError(e));
      return Future.error(e);
    } catch (e) {
      Fluttertoast.showToast(msg: '未知异常');
      return Future.error('未知异常');
    }
  }

  static void longPrint(String msg) {
    //因为String的length是字符数量不是字节数量所以为了防止中文字符过多，
    //  把4*1024的MAX字节打印长度改为1000字符数
    int maxStrLength = 500;
    //大于1000时
    while (msg.length > maxStrLength) {
      print(msg.substring(0, maxStrLength));
      msg = msg.substring(maxStrLength);
    }
    //剩余部分
    print(msg);
  }

  // 处理 Dio 异常
  static String _dioError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return "网络连接超时，请检查网络设置";
      case DioErrorType.receiveTimeout:
        return "服务器异常，请稍后重试！";
      case DioErrorType.sendTimeout:
        return "网络连接超时，请检查网络设置";
      case DioErrorType.response:
        return "服务器异常，请稍后重试！";
      case DioErrorType.cancel:
        return "请求已被取消，请重新请求";
      case DioErrorType.other:
        return "网络异常，请稍后重试！";
      default:
        return "Dio异常";
    }
  }

  // 处理 Http 错误码
  static String _handleHttpError(int errorCode) {
    String message = '';
    switch (errorCode) {
      case 400:
        message = '请求语法错误';
        break;
      case 401:
        message = '未授权，请登录';
        break;
      case 403:
        message = '拒绝访问';
        break;
      case 404:
        message = '请求出错';
        break;
      case 408:
        message = '请求超时';
        break;
      case 500:
        message = '服务器异常';
        break;
      case 501:
        message = '服务未实现';
        break;
      case 502:
        message = '网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      case 504:
        message = '网关超时';
        break;
      case 505:
        message = 'HTTP版本不受支持';
        break;
      default:
        message = '请求失败，错误码：$errorCode';
    }
    return message;
  }

  static Future<T> get<T>(String path, {Map? params, CancelToken? cancelToken}) {
    return _request(path, method: 'get', params: params, cancelToken: cancelToken);
  }

  static Future<T> post<T>(String path,
      {Map? params, data, CancelToken? cancelToken, String contentType = 'application/json'}) {
    return _request(path,
        method: 'post', params: params, data: data, cancelToken: cancelToken, contentType: contentType);
  }

  static Future<T> patch<T>(String path,
      {Map? params, data, CancelToken? cancelToken, String contentType = 'application/json'}) {
    return _request(path,
        method: 'patch', params: params, data: data, cancelToken: cancelToken, contentType: contentType);
  }

  static Future<T> put<T>(String path,
      {Map? params, data, CancelToken? cancelToken, String contentType = 'application/json'}) {
    return _request(path,
        method: 'put', params: params, data: data, cancelToken: cancelToken, contentType: contentType);
  }

  static Future<T> delete<T>(String path,
      {Map? params, data, CancelToken? cancelToken, String contentType = 'application/json'}) {
    return _request(path,
        method: 'delete', params: params, data: data, cancelToken: cancelToken, contentType: contentType);
  }
}
