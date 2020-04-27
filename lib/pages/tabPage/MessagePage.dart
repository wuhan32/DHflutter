import 'dart:collection';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oa/dao/ImMessage.dart';
import 'package:oa/generated/json/user_info_entity_helper.dart';
import 'package:oa/json/user_info_entity.dart';
import 'package:oa/modle/ImMessageItem.dart';
import 'package:oa/pages/MainPage.dart';
import 'package:oa/pages/im/ChatToUserPage.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oa/utils/ImWebsocketUtil.dart';


class MessagePage extends StatefulWidget {
  @override
  MessagePageState createState() => new MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  LinkedHashMap<String,ImMessageItem> userMessages=LinkedHashMap();
  //顺序转换队列
  LinkedHashMap<String,ImMessageItem> newUserMessages=LinkedHashMap<String,ImMessageItem>();
  //加载状态
  bool loadState=false;
  //重构页面函数
  static Function reBuildMessagePage;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: buildMessageList(),
    );
  }

  //构建聊天列表
  List<Widget> buildMessageList(){
    List<Widget> messageListWidgets=[];
    if(userMessages.length>0){
      userMessages.forEach((String userId,ImMessageItem imMessageItem){
        messageListWidgets.add(buildMessageItem(imMessageItem));
      });
    }else{
      if(!loadState){
        messageListWidgets.add(AspectRatio(
          aspectRatio: 1,
          child:Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.spinner,color: Colors.grey,size: 80,),
                Text("加载中...",style: TextStyle(fontSize: 18,color: Colors.grey,)),
              ],
            ),
          ),
        ));
      }else{
        messageListWidgets.add(AspectRatio(
          aspectRatio: 1,
          child:Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.comment,color: Colors.grey,size: 80,),
              Text("暂无消息",style: TextStyle(fontSize: 18,color: Colors.grey,)),
              ],
            ),
          ),
        ));
      }
    }
    return messageListWidgets;
  }

  //构建列表项
  Widget buildMessageItem(ImMessageItem imMessageItem){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          return ChatToUserPage(choiceUser: imMessageItem.userId,);
        })).then((_){
          setState(() {
            userMessages.clear();
            loadState=false;
          });
          //覆盖webSocket onMessage监听
          ImWebSocketUtil.setOnMessage(onMessage: onMessage);
          //加载本地聊天记录
          loadLocalMessageRecord();
        });
      },
      child: Card(
        elevation: 0.5,
        margin: EdgeInsets.only(top: 1),
        child: ListTile(
          leading: Container(
            margin: EdgeInsets.all(0),
            child: ClipOval(
              child: CachedNetworkImage(
                height: 35,
                width: 35,
                fit: BoxFit.cover,
                imageUrl:"${imMessageItem.userHeadPic}",
                placeholder: (context, url) =>  Container(
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  child: Icon(Icons.person),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(17.5),
                      color: Colors.grey
                  ),
                ),
              ),
            ),
          ),
          title: Text("${imMessageItem.userName}"),
          subtitle: Text("${imMessageItem.lastMessage}"),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("${DateTimeUtil.formatMessageDateTimeString(imMessageItem.lastMessageTime)}",style: TextStyle(fontSize: 12),),
              Container(
                height: 26,
                width: 26,
                child: Center(child: Text(imMessageItem.notReadCount>99?"99+":"${imMessageItem.notReadCount}",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w800),),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13), color: imMessageItem.notReadCount==0?Colors.white:Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //加载本地聊天记录
  void loadLocalMessageRecord()async{
    userMessages.clear();
    loadReadTotal();
    await ImWebSocketUtil.imMessageDao.getImMessageList().then((messageMapList){
        messageMapList.forEach((map)async{
          String targetUser=map[ImMessage.columnTargetUser];
          String lastMessage=map["lastMessage"];
          String lastMessageType=map["lastMessageType"];
          int lastMessageTime=map["lastMessageTime"];
          int notReadCount=map["noReadCount"];
          userMessages[targetUser]=ImMessageItem(
              userId: targetUser,
              lastMessage: lastMessage,
              lastMessageType: lastMessageType,
              lastMessageTime: lastMessageTime,
              notReadCount: notReadCount
          );
          Response response=await HttpUtil.getInstance(context).get("user/formLoad",data: {
            "id":targetUser
          });
          Map result=json.decode(response.data);
          setState(() {
              //加载成功
              UserInfoEntity userInfo=userInfoEntityFromJson(UserInfoEntity(), result);
              userMessages[targetUser].userHeadPic=userInfo.avater;
              userMessages[targetUser].userName=userInfo.chsname;
          });
        });
        setState(() {
          this.loadState=true;
        });
    });
  }


  //向消息队列头部添加一条消息
  addFirstMessage(String fromUser){
    newUserMessages[fromUser]=newUserMessages[fromUser];
    userMessages.forEach((userId,message){
      newUserMessages[userId]=message;
    });
    userMessages.clear();
    newUserMessages.forEach((newUserId,newMessage){
      userMessages[newUserId]=newMessage;
    });
    newUserMessages.clear();
  }



  void onMessage(String message){
    //保存到数据库
    ImMessage imMessage=ImMessage.fromMap(json.decode(message));
    ImWebSocketUtil.imMessageDao.insert(imMessage);
    MainPageState.mainMessageTip(true);
    //消息置顶
    addFirstMessage(imMessage.fromUser);
    //首次接收消息
    if(userMessages[imMessage.fromUser]==null){
      //初始化消息列表实体
      userMessages[imMessage.fromUser]=ImMessageItem();
      HttpUtil.getInstance(context).get("user/formLoad",data: {
        "id":imMessage.fromUser
      }).then((response){
        Map result=json.decode(response.data);
          setState(() {
            UserInfoEntity userInfo=userInfoEntityFromJson(UserInfoEntity(), result);
            userMessages[imMessage.fromUser].userId=userInfo.id;
            userMessages[imMessage.fromUser].userHeadPic=userInfo.avater;
            userMessages[imMessage.fromUser].userName=userInfo.chsname;
          });
      });
    }
    setState(() {
      //添加到页面实时数据
      userMessages[imMessage.fromUser].lastMessage=imMessage.message;
      userMessages[imMessage.fromUser].lastMessageType=imMessage.messageType;
      userMessages[imMessage.fromUser].lastMessageTime=imMessage.time;
      userMessages[imMessage.fromUser].notReadCount=userMessages[imMessage.fromUser].notReadCount+1;
    });
  }



  //重构页面
  void reBuildMessagePageFunction(){
    setState(() {
      //加载本地聊天记录
      loadLocalMessageRecord();
    });
  }


  //加载未读总数
  void loadReadTotal() async{
   int notReadTotal=await ImWebSocketUtil.imMessageDao.loadNotReadTotal();
    if(notReadTotal>0){
      MainPageState.mainMessageTip(true);
    }else{
      MainPageState.mainMessageTip(false);
    }
  }

  @override
  void initState() {
    //重载本地消息
    reBuildMessagePage=reBuildMessagePageFunction;
    //设置消息监听函数
    ImWebSocketUtil.setOnMessage(onMessage: onMessage);
    //加载本地聊天记录
    loadLocalMessageRecord();
    //覆盖webSocket onMessage监听
    super.initState();
  }

  @override
  void dispose() {
    reBuildMessagePage=null;
    ImWebSocketUtil.reSetOnMessage();
    super.dispose();
  }

  @override
  void didUpdateWidget(MessagePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}

