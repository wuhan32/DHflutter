import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:oa/generated/json/user_info_entity_helper.dart';
import 'package:oa/json/user_info_entity.dart';
import 'package:oa/pages/login/AccountPasswLoginPage.dart';
import 'package:oa/pages/MainPage.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oa/utils/ImWebsocketUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

//app鉴权工具类
class AuthUtil {
  //用户token键名
  static String tokenKey="token";
  //用户信息键名
  static String userInfoKey="userinfo";

  //注销登录
  static void logout(BuildContext context) async {
      //服务端token失效
      try{
        HttpUtil.getInstance(context).post("userinfo/appLogout").then((response)async{
          Map result=json.decode(response.data);
          if(result["status"]){
            //清除token
            await _deleteToken();
            //清除用户信息
            await _deleteUserInfo();
            //断开im连接
            ImWebSocketUtil.close();
            //跳转到登录页
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
                  return AccountPasswordLoginPage();
                }), (route) => route == null);
          }else{
            EasyLoading.showError(result["msg"]);
          }
        });
      }catch(e){
        //失败重试
        logout(context);
      }
  }

  //用户登录
  static void login(
      {@required String token,
      @required String userInfo,
      @required BuildContext context}) async {
    //保存token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
    //保存用户信息
    prefs.setString(userInfoKey, userInfo);
    //跳转到首页
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return MainPage();
    }), (route) => route == null);
  }

  //获取token
  static Future<String> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(tokenKey);
      return token;
    } catch(e){
      return null;
    }
  }

  //获取用户信息
  static Future<UserInfoEntity> getUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userInfoStr=prefs.getString(userInfoKey);
      return userInfoEntityFromJson(UserInfoEntity(),json.decode(userInfoStr));
    }catch(e){
      return null;
    }
  }

  //更新用户头像
  static Future<bool> updateUserHeadPic(String headPic) async {
     try{
       UserInfoEntity userInfo= await getUserInfo();
       userInfo.avater=headPic;
       SharedPreferences prefs = await SharedPreferences.getInstance();
       prefs.setString(userInfoKey, json.encode(userInfo));
       return true;
     }catch(e){
       return false;
     }
  }

  //更新用户信息
  static Future<bool> updateUserInfo(String userInfo) async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(userInfoKey,userInfo);
      return true;
    }catch(e){
      return false;
    }
  }

  //删除token
  static Future<bool> _deleteToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      return true;
    } catch(e){
      return false;
    }
  }

  //删除用户信息
  static Future<bool> _deleteUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(userInfoKey);
      return true;
    } catch(e){
      return false;
    }
  }

}
