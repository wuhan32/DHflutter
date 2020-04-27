import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oktoast/oktoast.dart';

//http工具类
class HttpUtil {
  //服务根地址
  static final baseUrl="www.dahengzh.com:8080/oa/";
  //static final baseUrl="192.168.0.133:8080/dhjs_web/";

  //http接口跟地址
  static final httpBaseUrl="http://$baseUrl";

  //单例模式
  static HttpUtil instance;
  //上下文
  static BuildContext context;
  //dio实例
  static Dio dio;
  //基础配置
  static BaseOptions options;
  //数据缓存配置
  static Options cacheOptions=buildCacheOptions(Duration(seconds: 1),maxStale: Duration(days: 7));

  static HttpUtil getInstance(BuildContext context){
    HttpUtil.context = context;
    if( HttpUtil.instance==null){
      HttpUtil.instance=_httpUtil();
    }
    return  HttpUtil.instance;
  }

  /*
   * 实例初始化配置
   */
  static _httpUtil() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    HttpUtil.options = BaseOptions(
      //请求基地址
      baseUrl: httpBaseUrl,
      //连接超时，单位--毫秒.
      connectTimeout: 10000,
      //响应流间隔时间，单位为毫秒。
      receiveTimeout: 5000,
      //请求的Content-Type，默认值"application/json; charset=utf-8",Headers.formUrlEncodedContentType自动编码请求体.
      contentType: Headers.formUrlEncodedContentType,
      //接受响应数据格式,四种类型 `json`, `stream`, `plain`, `bytes`. 默认值 `json`,
      responseType: ResponseType.json,
      //请求编码加密
      requestEncoder: null,
    );
    HttpUtil.dio = Dio(options);
    //添加请求,响应,错误拦截器
    HttpUtil.dio.interceptors.add(InterceptorsWrapper(onRequest: _onRequest, onResponse: _onResponse, onError: _onError));
    //数据缓存拦截器
    HttpUtil.dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: httpBaseUrl)).interceptor);
    return HttpUtil();
  }

  /*
   * get请求
   */
  get(String url, {Map<String, dynamic> data,Options options}) async {
    //默认加入缓存配置
    /*if(options==null){
      options=cacheOptions;
    }*/
    Response response;
    try {
      response =await dio.get(
          url,
          queryParameters: data,
          options:options,
          cancelToken: CancelToken()
      );
    } on DioError catch (e) {
      print("get erro---------$e");
    }
    return response;
  }

  /*
   * post请求
   */
  post(String url, {Map<String, dynamic> data,plainData,Options options}) async {
   Response response;
    try {
      response = await dio.post(
          url,
          data:plainData,
          queryParameters: data,
          options:options,
          cancelToken: CancelToken()
      );
    } on DioError catch (e) {
      print("post erro---------$e");
    }
    return response;
  }

  /*
   *文件上传
   */
  uploadFile(url, {data,Options options}) async {
    Response response;
    try {
      response =await dio.post(
          url,
          data: data,
          options:options,
          cancelToken: CancelToken()
      );
    } on DioError catch (e) {
      print("post erro---------$e");
    }
    return response;
  }


  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    Response response;
    try {
      response = await dio.download(
        urlPath,
        savePath,
        onReceiveProgress: (int count, int total) {
          //进度
          print("$count $total");
        },
        cancelToken: CancelToken(),
      );
    } on DioError catch (e) {
      print('downloadFile error---------$e');
    }
    return response.data;
  }

  //请求拦截器
  static _onRequest(RequestOptions options) async {
    //添加设备信息
    if (Platform.isIOS) {
      options.headers["user-agent"] = "iPhone";
    } else if (Platform.isAndroid) {
      options.headers["user-agent"] = "Android";
    }
    String token=await AuthUtil.getToken();
    //添加用户鉴权token
    options.headers["token"] = token;
    //显示加载动画
    EasyLoading.show();
  }

  //响应拦截
  static _onResponse(Response response) async {
    //关闭加载动画
    EasyLoading.dismiss();
    //响应数据格式判断
    if(json.decode(response.data) is Map<dynamic,dynamic>){
      Map resultData = json.decode(response.data);
      //服务器返回登录信息失效
      if (resultData["code"] != null && resultData["code"] == "need-login") {
        //取消本次请求
        response.request.cancelToken.cancel("need-login");
        //注销app端登录
        AuthUtil.logout(context);
      }
    }
  }

  //异常拦截
  static _onError(DioError e) {
    //关闭加载动画
    EasyLoading.dismiss();
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      showToast("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      showToast("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      showToast("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      showToast("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      if (e.error.toString() == "need-login") {
        showToast("登录信息失效");
      } else {
        showToast("请求取消");
      }
      //身份认证不通过,主动取消请求
    } else {
      showToast("网络出错");
    }
  }
}
