import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oa/generated/json/user_info_entity_helper.dart';
import 'package:oa/json/user_info_entity.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';


class MineDetailEditPage extends StatefulWidget {
  @override
  MineDetailEditPageState createState() => new MineDetailEditPageState();
}

class MineDetailEditPageState extends State<MineDetailEditPage> {
  //用户信息
  UserInfoEntity userInfo=UserInfoEntity();

  //表单控制器
  TextEditingController userNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController mobileController=TextEditingController();
  TextEditingController enameController=TextEditingController();
  TextEditingController usernoController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text('修改资料'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              //修改资料
              HttpUtil.getInstance(context).post("user/save",data: userInfoEntityToJson(userInfo)).then((response){
                Map result=json.decode(response.data);
                if(result["status"]){
                  showToast("已保存");
                  //修改本地用户数据
                  AuthUtil.updateUserInfo(json.encode(userInfoEntityToJson(userInfo)));
                }else{
                  showToast(result["msg"]);
                }
              });
            },
          )
        ],
      ),
      body: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 20),
                child:TextField(
                  controller: userNameController,
                  textAlign: TextAlign.end,
                  onChanged:(value)=>this.userInfo.chsname=value.trim(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20,right: 30),
                    hintText: "姓名",
                    prefixIcon:Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("姓名",style: TextStyle(color: Colors.blue,fontSize: 22),),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
              ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: TextField(
                controller: mobileController,
                textAlign: TextAlign.end,
                onChanged:(value)=>this.userInfo.mobile=value.trim(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20,right: 30),
                  hintText: "电话号码",
                  prefixIcon:Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text("电话",style: TextStyle(color: Colors.blue,fontSize: 22)),
                  ),
                ),
                style: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: TextField(
                controller: emailController,
                textAlign: TextAlign.end,
                onChanged:(value)=>this.userInfo.email=value.trim(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20,right: 30),
                  hintText: "电子邮箱",
                  prefixIcon:Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text("邮箱",style: TextStyle(color: Colors.blue,fontSize: 22)),
                  ),
                ),
                style: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: TextField(
                enabled: false,
                controller: usernoController,
                textAlign: TextAlign.end,
                onChanged:(value)=>this.userInfo.userno=value.trim(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20,right: 30),
                  hintText: "用户编号",
                  prefixIcon:Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text("编号",style: TextStyle(color: Colors.blue,fontSize: 22)),
                  ),
                ),
                style: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: TextField(
                enabled: false,
                controller: enameController,
                textAlign: TextAlign.end,
                onChanged:(value)=>this.userInfo.ename=value.trim(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20,right: 30),
                  hintText: "账号",
                  prefixIcon:Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text("账号",style: TextStyle(color: Colors.blue,fontSize: 22)),
                  ),
                ),
                style: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
          ],
      ),
    );
  }





  void loadUserInfo()async{
    await AuthUtil.getUserInfo().then((userInfo) {
      setState(() {
       this.userInfo = userInfo;
        //设置初始值
        userNameController.value=TextEditingValue(text: this.userInfo.chsname==null?"":this.userInfo.chsname);
        emailController.value=TextEditingValue(text: this.userInfo.email==null?"":this.userInfo.email);
        mobileController.value=TextEditingValue(text: this.userInfo.mobile==null?"":this.userInfo.mobile);
        enameController.value=TextEditingValue(text: this.userInfo.ename==null?"":this.userInfo.ename);
        usernoController.value=TextEditingValue(text: this.userInfo.userno==null?"":this.userInfo.userno);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(MineDetailEditPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
