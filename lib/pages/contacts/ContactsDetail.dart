
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oa/components/FadeRoute.dart';
import 'package:oa/components/PhotoViewSimpleScreen.dart';
import 'package:oa/generated/json/user_info_entity_helper.dart';
import 'package:oa/json/user_info_entity.dart';
import 'package:oa/pages/im/ChatToUserPage.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oa/utils/ImWebsocketUtil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsDetailPage extends StatefulWidget {

  final String contractUserId;

  ContactsDetailPage({Key key,@required this.contractUserId}):super(key:key);

  @override
  ContactsDetailPageState createState() => new ContactsDetailPageState();
}

class ContactsDetailPageState extends State<ContactsDetailPage>{

  //用户信息
  UserInfoEntity userInfo=UserInfoEntity();
  //登录用户id
  String loginUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.userInfo.chsname==null?"":this.userInfo.chsname),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: AspectRatio(
              aspectRatio: 0.8,
              child: Column(
                children: <Widget>[
                  buildHeadPic(),
                  buildInfoItem(Icons.person, "姓名", this.userInfo.chsname),
                  Divider(),
                  buildInfoItem(Icons.group, "部门", this.userInfo.orgname),
                  Divider(),
                  buildInfoItem(Icons.work, "职位", this.userInfo.title),
                  Divider(),
                  buildInfoItem(Icons.person_add, "领导", this.userInfo.immediateleader),
                  Divider(),
                  buildInfoItem(Icons.phone, "手机", this.userInfo.mobile),
                  Divider(),
                  buildInfoItem(Icons.email, "邮箱", this.userInfo.email),
                ],
              ),
            ),
          ),
          buildUserAction()
        ],
      ),
    );
  }



  //构建头像
  Widget buildHeadPic() {
    return Expanded(
        flex: 3,
        child: Container(
          child: Center(
            child: GestureDetector(
              onTap: (){
                _lookUserHeadPic();
              },
              child: Container(
                alignment: Alignment.center,
                child: ClipOval(
                  child: CachedNetworkImage(
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    imageUrl: this.userInfo.avater==null?"":this.userInfo.avater,
                    placeholder: (context, url) => Container(
                      height: 80,
                      width: 80,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 80,
                      width: 80,
                      alignment: Alignment.center,
                      child: Icon(Icons.person,size: 40,color: Colors.grey,),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white70
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Color(0xFFedeeef),
            border:Border.lerp(Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1),width: 1)), null,0.3),
          ),
        )
    );
  }

  //构建功能
  buildUserAction(){
    if(this.userInfo.id==this.loginUserId){
      return Container();
    }else{
      return Container(
        padding: EdgeInsets.only(left: 30,right: 30),
        child: AspectRatio(
          aspectRatio: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  child: GestureDetector(
                    onTap: (){
                      //打电话
                      Navigator.pop(context);
                      if(this.userInfo.mobile!=null&&this.userInfo.mobile.trim()!=""){
                        launch("tel:" + this.userInfo.mobile).then((_){
                          ImWebSocketUtil.reSetOnMessage();
                        });
                      }else{
                        showToast("电话号码不能为空");
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 30,right: 30),
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.phone,size: 30,color: Colors.white),
                          Text("打电话",style: TextStyle(fontSize: 20,color: Colors.white),)
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                    ),
                  )
              ),
              SizedBox(
                width: 30,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    //发消息
                    Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context){
                      return ChatToUserPage(choiceUser:this.userInfo.id);
                    })).then((_){
                      ImWebSocketUtil.reSetOnMessage();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 30,right: 30),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.message,size: 30,color: Colors.white,),
                        Text("发消息",style: TextStyle(fontSize: 20,color: Colors.white),)
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }



  //构建信息项
  Widget buildInfoItem(IconData iconData, String itemName, String itemValue){
    return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.only(left: 15,right: 15),
          height: 25,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("$itemName\\",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          )
                      ),
                      Icon(
                        iconData,
                        color: Colors.lightBlueAccent,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      itemValue==null?"":itemValue,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    )),
              )
            ],
          ),
        ));
  }

  //加载联系人信息
  loadContractUserInfo()async{
    HttpUtil.getInstance(context).get("user/formLoad",data: {
      "id":widget.contractUserId
    }).then((response){
      print(response.data);
      Map result=json.decode(response.data);
      setState(() {
        this.userInfo=userInfoEntityFromJson(UserInfoEntity(), result);
      });
    });
  }



  //查看用户头像
  _lookUserHeadPic() {
    Navigator.of(context)
        .push(FadeRoute(
        page: NetWorkPhotoViewSimpleScreen(
          imageUrl:this.userInfo.avater,
          heroTag: 'simple',
        )));
  }

  //加载登录用户信息
  void loadLoginUserInfo()async{
    this.loginUserId=(await AuthUtil.getUserInfo()).id;
  }


  @override
  void initState() {
    loadLoginUserInfo();
    loadContractUserInfo();
    super.initState();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(ContactsDetailPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

}