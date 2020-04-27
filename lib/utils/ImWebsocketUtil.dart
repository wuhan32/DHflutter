import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:oa/dao/ImMessage.dart';
import 'package:oa/pages/MainPage.dart';
import 'package:oa/utils/AudioPlayerUtil.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oa/utils/HttpUtil.dart';

class ImWebSocketUtil{

  //即时通讯WebSocket
  static WebSocket webSocket;
  //即时消息dao
  static ImMessageDao imMessageDao;
  //消息事件处理函数
  static Function _onMessage;
  //im连接状态
  static bool imConnectState=false;
  //心跳检测定时器
  static Timer checkImConnectStateTimer;
  //失败重连计数器
  static int reConnectCount=0;





  //打开一个im连接(默认消息处理函数:保存到数据库)
  static Future<bool> openImServer() async{
    await ImMessageDao.getInstance().then((messageDao){
      imMessageDao=messageDao;
      _onMessage=_onMessageSaveDataBase;
      _openImWebSocket();
    });
    return true;
  }

  //开启WebSocket
  static void _openImWebSocket()async{
    try{
      //启动前关闭之前连接,保证内存不会泄露
      webSocket?.close();
      String token = await AuthUtil.getToken();
      //开启一个新的WebSocket连接
      webSocket= await WebSocket.connect("ws://${HttpUtil.baseUrl}im/$token");
      //添加监听器
      webSocket.listen((dynamic message){
        //响应服务端心跳检测
        if(message.toString()=="ping"){
          webSocket.add("pong");
        }else if(message.toString()=="pong"){
          //客户端心跳检测成功
          imConnectState=true;
          //消息处理逻辑
        }else{
          //声音提示
          AudioPlayerUtil.localPlay("audio/message.mp3");
          _onMessage(message.toString());
        }
      }, onDone: () {
        print("即时通讯关闭???");
      }, onError: (e) {
        print("即时通讯发生错误XXX");
      });
      //连接成功
      imConnectState=true;
      //启动心跳检测
      _startHeartCheck();
      //重置失败重连计数器
      reConnectCount=0;
      print('即时通讯连接成功!!!');
    }catch(e){
      print("即时通讯连接失败:${e.toString()}");
      if(reConnectCount>=3){
        print("3次尝试重连失败,放弃连接");
        //重置失败重连计数器
        reConnectCount=0;
        return;
      }else{
        reConnectCount++;
        print("1秒后尝试第 $reConnectCount 次重连...");
       Future.delayed(Duration(seconds: 1),(){
         _openImWebSocket();
       });
      }
    }
  }

  //启动心跳检测
  static void _startHeartCheck(){
    checkImConnectStateTimer?.cancel();
    checkImConnectStateTimer=Timer.periodic(Duration(seconds: 5), (timer) {
      imConnectState=false;
      webSocket.add("ping");
      Timer(Duration(seconds: 2), (){
        if(!imConnectState){
            print("websocket 失去连接");
            checkImConnectStateTimer?.cancel();
            _openImWebSocket();
        }else{
            print("websocket 连接健康");
        }
      });
    });
  }

  //全局消息处理
  static void _onMessageSaveDataBase(String content) {
    MainPageState.mainMessageTip(true);
    imMessageDao.insert(ImMessage.fromMap(json.decode(content.toString())));
  }

  //关闭WebSocket服务
  static void close(){
    checkImConnectStateTimer?.cancel();
    webSocket?.close();
    imMessageDao?.closeDb();
  }

  //设置消息接收处理函数(自定义)
  static void setOnMessage({@required void onMessage(String data)}){
    _onMessage=onMessage;
  }

  //重置消息接收处理函数(保存到数据库)
  static void reSetOnMessage(){
    _onMessage=_onMessageSaveDataBase;
  }

  //发送消息
  static void send(String message){
    webSocket.add(message);
  }
}