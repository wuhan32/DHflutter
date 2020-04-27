import 'dart:async';
import 'dart:convert';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oa/components/AlertWidget.dart';
import 'package:oa/dao/ImMessage.dart';
import 'package:oa/generated/json/user_info_entity_helper.dart';
import 'package:oa/json/user_info_entity.dart';
import 'package:oa/pages/MainPage.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oa/utils/Constants.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oa/utils/ImWebsocketUtil.dart';
import 'package:http_parser/http_parser.dart';

class ChatToUserPage extends StatefulWidget {
  final String choiceUser;
  ChatToUserPage({Key key, @required this.choiceUser}) : super(key: key);
  @override
  ChatToUserPageState createState() => ChatToUserPageState();
}

class ChatToUserPageState extends State<ChatToUserPage> {
  //Tab页的控制器，可以用来定义Tab标签和内容页的坐标
  final TextEditingController textController = TextEditingController();
  //消息
  List<ImMessage> messageList = <ImMessage>[];
  //滑动控制器
  ScrollController scrollController = ScrollController();
  //对方用户信息
  UserInfoEntity choiceUserInfo = UserInfoEntity();
  //当前用户信息
  UserInfoEntity loginUserInfo = UserInfoEntity();
  //像素比例
  double pixelRatio;
  //倍率
  double px;
  //对方样式
  BubbleStyle styleChoiceUser;
  //我的样式
  BubbleStyle styleMe;
  //消息内容
  String messageContent;

  @override
  Widget build(BuildContext context) {
    //发送事件到子页面
    initParams();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("${choiceUserInfo.chsname}"),
        centerTitle: true,
        actions: <Widget>[
          // 非隐藏的菜单
          IconButton(
              icon: Icon(Icons.delete_forever),
              tooltip: '清空记录',
              onPressed: () {
                clearMessageList();
              }),
        ],
      ),
      body: new Builder(builder: (BuildContext context) {
        return Column(children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              color: Colors.white30,
              child: ListView.builder(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                itemCount: messageList.length,
                itemBuilder: (context, i) {
                  return buildMessageItem(messageList[i]);
                },
              ),
            ),
          ),
          Divider(height: 1.0),
          Container(
            child: buildComposer(),
            decoration:
                BoxDecoration(color: Color.fromRGBO(241, 243, 244, 0.9)),
          ),
        ]);
      }),
      resizeToAvoidBottomPadding: true,
    );
  }


  //初始化参数
  initParams() {
    this.pixelRatio = MediaQuery.of(context).devicePixelRatio;
    this.px = 1 / pixelRatio;
    this.styleChoiceUser = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 3.0, right: 150.0),
      alignment: Alignment.topLeft,
    );
    this.styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 3.0, left: 150.0),
      alignment: Alignment.topRight,
    );
  }



  //加载用户信息(当前用户&&对方用户)
  loadUserInfo() async {
    this.loginUserInfo = await AuthUtil.getUserInfo();
    HttpUtil.getInstance(context).get("user/formLoad",
        data: {"id": widget.choiceUser}).then((response) {
      Map result = json.decode(response.data);
        setState(() {
          this.choiceUserInfo = userInfoEntityFromJson(
              UserInfoEntity(), result);
        });
    });
  }


  //加载本地消息
  loadLocalMessage() async {
    ImWebSocketUtil.imMessageDao.getUserMessageList(widget.choiceUser).then((messages) {
      setState(() {
        messageList.clear();
        this.messageList.addAll(messages);
        Timer(Duration(milliseconds: 100), (){
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      });
    });
    //设置消息已读
    ImWebSocketUtil.imMessageDao.setMessageReadState(widget.choiceUser);
  }


  //构建聊天输入框
  Widget buildComposer() {
    return IconTheme(
      data: IconThemeData(color: Color.fromRGBO(241, 243, 244, 0.9)),
      child: Container(
        alignment: Alignment.center,
        height: 95.0,
        margin: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 45.0,
              margin: const EdgeInsets.all(0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      textInputAction: TextInputAction.send,
                      controller: textController,
                      onChanged: (value){
                        setState(() {
                          this.messageContent=value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        hintText: "想说点儿什么？",
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    padding: EdgeInsets.only(top: 10,bottom: 10),
                    textColor: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Text("发送"),
                        SizedBox(width: 5,),
                        Icon(Icons.send,),
                      ],
                    ),
                    onPressed: messageContent==null||messageContent.trim()==""?null:submitMsg,
                    color: Colors.blue,
                    disabledColor: Colors.grey,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              margin: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    iconSize: 30,
                    color: Colors.amber,
                    icon:Icon(Icons.insert_emoticon),
                    onPressed: (){

                    },
                  ),
                  IconButton(
                    iconSize: 30,
                    color: Colors.red,
                    icon:Icon(Icons.star_border),
                    onPressed: (){

                    },
                  ),
                  IconButton(
                    iconSize: 30,
                    color: Colors.brown,
                    icon:Icon(Icons.photo_library),
                    onPressed: (){
                      _selectedImage();
                    },
                  ),
                  IconButton(
                    iconSize: 30,
                    color: Colors.black54,
                    icon:Icon(Icons.photo_camera),
                    onPressed: (){
                      _cameraImage();
                    },
                  ),
                  IconButton(
                    iconSize: 30,
                    color: Colors.blue,
                    icon:Icon(Icons.add),
                    onPressed: (){

                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //选择本地图片
  void _selectedImage() async {
    ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        String path = image.path;
        String name = path.substring(path.lastIndexOf("/") + 1, path.length);
        String suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
        FormData formData = FormData.fromMap({
          "file": MultipartFile.fromFileSync(path,
              filename: name, contentType: MediaType.parse("image/$suffix"))
        });
        /*HttpUtil.getInstance(context)
            .uploadFile("userinfo/updateUserheadPic", data: formData)
            .then((response) {
          Map result = json.decode(response.data);
          if (result["status"] != null && result["status"]) {
            AuthUtil.updateUserHeadPic(result["data"]).then((valeu) {
              showToast("更换成功!");
              loadUserInfo();
            });
          } else {
            showToast("头像上传失败!");
          }
        });*/
      }
    });
  }



  //拍照
  void _cameraImage() async {
    ImagePicker.pickImage(source: ImageSource.camera).then((image) {
      if (image != null) {
        String path = image.path;
        String name = path.substring(path.lastIndexOf("/") + 1, path.length);
        String suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
        FormData formData = FormData.fromMap({
          "file": MultipartFile.fromFileSync(path,
              filename: name, contentType: MediaType.parse("image/$suffix"))
        });
        /*HttpUtil.getInstance(context)
            .uploadFile("userinfo/updateUserheadPic", data: formData)
            .then((response) {
          Map result = json.decode(response.data);
          if (result["status"] != null && result["status"]) {
            AuthUtil.updateUserHeadPic(result["data"]).then((valeu) {
              showToast("更换成功!");
              loadUserInfo();
            });
          } else {
            showToast("头像上传失败!");
          }
        });*/
      }
    });
  }


  Future<Null> openAction() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text("相机拍摄"),
                onTap: () async {

                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("照片库"),
                onTap: () async {
                  await ImagePicker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }



  //清空消息记录
  clearMessageList() {
    showDialog(
        context: context,
        builder: (context) => AlertWidget(
            title: '清空记录',
            message: '确定清空该会话的全部记录吗？',
            confirmCallback: () {
              ImWebSocketUtil.imMessageDao.deleteChooseMessageRecord(widget.choiceUser).then((num){
                EasyLoading.showInfo("清空$num条记录");
                loadLocalMessage();
              });
            }
           )
    );
  }


  /*图片控件*/
  Widget imageView(imgPath) {
    if (imgPath == null) {
      return Center(
        child: Text("请选择图片或拍照"),
      );
    } else {
      return Image.file(
        imgPath,
      );
    }
  }


  //提交文本消息
  void submitMsg() async {
    if (messageContent == null || messageContent.trim() == "") {
      return;
    }else{
      ImMessage message=ImMessage(
        fromUser:this.loginUserInfo.id,
        toUser: this.choiceUserInfo.id,
        message: messageContent,
        messageType: Constants.messageTypeText,
        time: DateTime.now().millisecondsSinceEpoch,
        state:1
      );
      try{
        ImWebSocketUtil.send(json.encode(message.toMap()));
        ImWebSocketUtil.imMessageDao.insert(message);
        setState(() {
          messageList.add(message);
          Timer(Duration(milliseconds: 100), (){
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
        });
      }catch(e){
        EasyLoading.showError("发送失败,请稍后重试!");
      }
    }
    setState(() {
      messageContent=null;
      textController.clear();
    });
  }



  //构建聊天气泡
  Widget buildMessageItem(ImMessage imMessage) {
    //检测是否是对方发来的消息
    bool isChoiceUser = widget.choiceUser == imMessage.fromUser;
    //聊天消息子组件
    List<Widget> rowChildren=List<Widget>();
    //头像
    rowChildren.add(
        ClipOval(
          child: CachedNetworkImage(
            height: 35,
            width: 35,
            fit: BoxFit.cover,
            imageUrl:isChoiceUser?"${choiceUserInfo.avater}":"${loginUserInfo.avater}",
            placeholder: (context, url) => Container(
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
        )
    );
    //聊天气泡+时间
    rowChildren.add(
        Expanded(
          child: Column(
            crossAxisAlignment: isChoiceUser?CrossAxisAlignment.start:CrossAxisAlignment.end,
            children: <Widget>[
              Bubble(
                  padding: BubbleEdges.all(10),
                  style: isChoiceUser ? styleChoiceUser : styleMe,
                  child:Text('${imMessage.message}',style: TextStyle(fontSize: 18),)
              ),
              Container(
                margin: EdgeInsets.only(left: isChoiceUser?10:0,right: isChoiceUser?0:10,top: 5),
                child: Text('${DateTimeUtil.formatMessageDateTimeString(imMessage.time)}',style: TextStyle(fontSize: 10),),
              ),
            ],
          )
      )
    );
    return Container(
      margin: EdgeInsets.only(bottom: 5,top: 5,left: isChoiceUser?5:0,right: isChoiceUser?0:5,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isChoiceUser?rowChildren:rowChildren.reversed.toList(),
      ),
    );
  }


  void onMessage(String message){
    //保存到数据库
    ImMessage imMessage = ImMessage.fromMap(json.decode(message));
    //消息发送者是当前用户,展示消息
    if (imMessage.fromUser == widget.choiceUser) {
      //当前聊天用户默认已读
      imMessage.state = 1;
      //保存聊天记录
      ImWebSocketUtil.imMessageDao.insert(imMessage);
      setState(() {
        this.messageList.add(imMessage);
        Timer(Duration(milliseconds: 100), (){
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      });
    }else{
      //非当前聊天用户
      //保存记录
      ImWebSocketUtil.imMessageDao.insert(imMessage);
      MainPageState.mainMessageTip(true);
    }
    //存储
  }


  @override
  void initState() {
    super.initState();
    ImWebSocketUtil.setOnMessage(onMessage: onMessage);
    loadUserInfo();
    loadLocalMessage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}
