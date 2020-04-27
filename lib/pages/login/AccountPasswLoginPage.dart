import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oa/pages/login/SmsCodeLoginPage.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oa/utils/MD5Util.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oktoast/oktoast.dart';

//账户密码登录
class AccountPasswordLoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<AccountPasswordLoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _account, _password;
  RegExp mobileReg = new RegExp(r'^1[3456789]\d{9}$');
  bool _isObscure = true;
  Color _eyeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: this._formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                SizedBox(height: 70.0),
                buildAccountTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                SizedBox(height: 20.0),
                buildSmsLoginButton(),
                SizedBox(height: 80.0),
                buildLoginButton(context),
              ],
            )
        )
    );
  }

  //构建标题
  Widget buildTitle() {
    return Container(
        margin: EdgeInsets.only(top: 50),
        child: Center(
          child: Text(
            '大恒OA系统',
            style: TextStyle(fontSize: 42.0, color: Colors.blue),
          ),
        ));
  }

  //构建账号输入框
  Widget buildAccountTextField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_box,size: 30,),
        hintText: "请输入账号",
      ),
      validator: (value){
        if(value==""){
          return "请输入账号";
        }else{
          return null;
        }
      },
      keyboardType: TextInputType.text,
      onSaved: (String value) => this._account = value,
      style: TextStyle(
          fontSize: 25
      ),
    );
  }

  //构建密码输入框
  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => this._password = value,
      obscureText: this._isObscure,
      keyboardType: TextInputType.text,
      style: TextStyle(
        fontSize: 25
      ),
      validator: (value){
        if(value==""){
          return "请输入密码";
        }else{
          return null;
        }
      },
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock,size: 30,),
          hintText: "请输入密码",
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: this._eyeColor,
              ),
              onPressed: () {
                setState(() {
                  this._isObscure = !this._isObscure;
                  this._eyeColor = this._isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })
      ),
    );
  }

  //构建登录按钮
  Widget buildLoginButton(BuildContext context) {
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
                      userInfo: json.encode(result["data"]
                          ["user"]), //encode之后才会以json格式存储起来,直接tostring是不行的
                      context: context);
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

  //构建验证码登录跳转
  Widget buildSmsLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
            child: Text(
              "忘记密码?",
              style: TextStyle(color: Colors.blue,fontSize: 20),
            ),
            onPressed: () {
              /*Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return SmsCodeLoginPage();
              }));*/
              print("忘记密码");

        }),
        FlatButton(
            child: Text(
              "短信验证码登录",
              style: TextStyle(color: Colors.blue,fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return SmsCodeLoginPage();
              }));
            })
      ],
    );
  }

  //登录逻辑
  Future<Map> doLogin() async {
    Response result =
        await HttpUtil.getInstance(context).post("userinfo/appLogin", data: {
      "userName": this._account,
      "passWord": MD5Util.generateMd5(this._password),
    });
    return json.decode(result.data);
  }
}
