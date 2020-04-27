import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';




//验证码登录
class SmsCodeLoginPage extends StatefulWidget {
  @override
  SmsCodeLoginPageState createState() => new SmsCodeLoginPageState();
}

class SmsCodeLoginPageState extends State<SmsCodeLoginPage> {
  final _formKey = GlobalKey<FormState>();
  //手机号
  String _mobile;
  //验证码
  String _validCode;
  //手机号验证正则表达式
  RegExp mobileReg = new RegExp(r'^1[3456789]\d{9}$');
  //验证码验证正则表达式
  RegExp validCodeReg = new RegExp(r'^\d{4}$');
  //按钮显示剩余秒数
  int surplusSeconds=0;
  //剩余秒数计数器
  Timer surplusSecondsTimer;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('验证码登录'),
        centerTitle: true,
      ),
      body: Form(
          key: this._formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22.0),
            children: <Widget>[
              SizedBox(
                height: kToolbarHeight,
              ),
              SizedBox(height: 70.0),
              buildMobileTextField(),
              SizedBox(height: 30.0),
              buildSmsValidCodeTextField(),
              SizedBox(height: 80.0),
              buildLoginButton(),
            ],
          )
      ),
    );
  }


  //构建手机号输入框
  Widget buildMobileTextField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone_iphone,size: 30,),
        hintText: "请输入手机号",
      ),
      validator: (value){
        if(value==null||!mobileReg.hasMatch(value)){
          return "请输入正确的手机号";
        }else{
          return null;
        }
      },
      keyboardType: TextInputType.phone,
      onChanged: (String value){
        setState(() {
          this._mobile = value;
        });
      },
      style: TextStyle(
          fontSize: 25
      ),
    );
  }

  //构建验证码输入框
  Widget buildSmsValidCodeTextField() {
    return TextFormField(
      onSaved: (String value) => this._validCode = value,
      keyboardType: TextInputType.text,
      style: TextStyle(
          fontSize: 25
      ),
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.developer_mode,size: 30,),
          hintText: "请输入验证码",
          suffixIcon: RaisedButton(
            padding: EdgeInsets.only(left: 15,right: 15),
            elevation: 0,
            child: Text(surplusSeconds>0?"$surplusSeconds秒后可重新获取":"获取验证码"),
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.white,
            onPressed: _mobile==null||_mobile==""||surplusSeconds>0?null:sendSmsLoginValidCode,
          )
      ),
      validator: (value){
        if(value==null||!validCodeReg.hasMatch(value)){
          return "请输入4位验证码";
        }else{
          return null;
        }
      },
    );
  }

  //发送验证码
  sendSmsLoginValidCode()async{
      if(_mobile==null||!mobileReg.hasMatch(_mobile)){
        showToast("手机号格式错误");
      }else{
        HttpUtil.getInstance(context).get(
            "userinfo/appSendLoginValidcode",
            data: {
              "mobile":_mobile
            }
        ).then((response){
          Map result=json.decode(response.data);
          if(result["status"]){
            setState(() {
              surplusSeconds=300;
            });
            EasyLoading.showSuccess("发送成功!");
            surplusSecondsTimer=Timer.periodic(Duration(seconds: 1), (timer){
              if(surplusSeconds>0){
                setState(() {
                  surplusSeconds--;
                });
              }else{
                surplusSecondsTimer?.cancel();
              }
            });
          }else{
            showToast(result["msg"]);
          }
        });
      }
  }

  //构建登录按钮
  Widget buildLoginButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '登录',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.blue,
          onPressed: () {
            if (this._formKey.currentState.validate()) {
              //只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              //执行登录方法
              doLogin().then((result) {
                if (result["status"]) {
                  //登录APP
                  AuthUtil.login(
                      token: result["data"]["token"].toString(),
                      userInfo: json.encode(result["data"]["user"]), //encode之后才会以json格式存储起来,直接tostring是不行的
                      context: context
                  );
                } else {
                  showToast(result["msg"]);
                }
              });
            }
          },
          shape: StadiumBorder(side: BorderSide(color: Colors.blue)),
        ),
      ),
    );
  }


  //登录逻辑
  Future<Map> doLogin() async {
    Response result = await HttpUtil.getInstance(context).post("userinfo/appSmsLogin", data: {
      "mobile": this._mobile,
      "validCode": this._validCode,
    });
    return json.decode(result.data);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    surplusSecondsTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(SmsCodeLoginPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}