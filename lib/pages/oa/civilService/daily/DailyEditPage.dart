import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/components/AlertWidget.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../utils/HttpUtil.dart';

class DailyEditPage extends StatefulWidget{

  final String Id;//id
  DailyEditPage(this.Id) : super();

  @override
  _DailyEditPageState createState()=> new _DailyEditPageState();
}

class _DailyEditPageState extends State<DailyEditPage>{

  //对象数据
  var info = {};

  String starttime = "";//开始日期
  String endtime = "";//结束日期
  String title = "";//标题
  String remark = "";//内容

  //通过controller   给输入框默认值
  var _starttime = new TextEditingController();
  var _endtime = new TextEditingController();
  var _title = new TextEditingController();
  var _remark = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Center(
          child: new Text("添加领导日程"),
        ),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  new Expanded(flex: 2, child: Divider(color: Colors.transparent,)),
                  new Expanded(
                    flex: 25,
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                          labelText: '开始日期',
                          contentPadding: EdgeInsets.all(0)
                      ),
                      keyboardType: TextInputType.text,
                      controller: this._starttime,
                      validator: (String value){
                        return value.length>0?null:"请选择开始日期";
                      },
                      onSaved: (String value) => this.starttime = value.trim(),
                    ),
                  ),
                  new Expanded(
                    flex: 15,
                    child: new MaterialButton(
                      child: new Text('选择日期'),
                      onPressed: () {
                        // 调用函数打开
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(info["starttime"]),
                          firstDate: DateTime.parse(info["starttime"])
                              .subtract(new Duration(days: 3000)), // 减 30 天
                          lastDate: DateTime.parse(info["starttime"])
                              .add(new Duration(days: 3000)), // 加 30 天
                        ).then((DateTime val) {
                          print(val.year); // 2018-07-12 00:00:00.000

                          int month=val.month;
                          String months="";
                          if(month<=9){
                            months="0"+month.toString();
                          }else{
                            months=month.toString();
                          }
                          int days=val.day;
                          String dayss="";
                          if(days<=9){
                            dayss="0"+days.toString();
                          }else{
                            dayss=days.toString();
                          }
                          String date=val.year.toString()+'-'+months+"-"+dayss;
                          if(this.endtime ==null || this.endtime=='') {
                            setState(() {
                              this._starttime.text=date;
                              this.starttime = date;
                            });
                          }else{
                            var startTime = DateTime.parse(date).millisecondsSinceEpoch;//返回时间戳
                            var endTime = DateTime.parse(this.endtime).millisecondsSinceEpoch;//返回时间戳
                            if(startTime<=endTime){//结束时间要大于开始时间
                              setState(() {
                                this._starttime.text=date;
                                this.starttime = date;
                              });
                            }else{
                              showToast("结束日期要小于开始日期！");
                            }
                          }
                        }).catchError((err) {
                          print(err);
                        });
                      },
                    ),
                  ),
                  new Expanded(flex:2,child: Divider(color: Colors.transparent,)),
                ],
              ),
              Divider(
                height: 20,
                color: Colors.transparent,
              ),
              Row(
                children: <Widget>[
                  new Expanded(flex: 2, child: Divider(color: Colors.transparent,)),
                  new Expanded(
                    flex: 25,
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                          labelText: '结束日期',
                          contentPadding: EdgeInsets.all(0)
                      ),
                      keyboardType: TextInputType.text,
                      controller: this._endtime,
                      validator: (String value){
                        return value.length>0?null:"请选择结束日期";
                      },
                      onSaved: (String value) => this.endtime = value.trim(),
                    ),
                  ),
                  new Expanded(
                    flex: 15,
                    child: new MaterialButton(
                      child: new Text('选择日期'),
                      onPressed: () {
                        // 调用函数打开
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(info["endtime"]),
                          firstDate: DateTime.parse(info["endtime"])
                              .subtract(new Duration(days: 3000)), // 减 30 天
                          lastDate: DateTime.parse(info["endtime"])
                              .add(new Duration(days: 3000)), // 加 30 天 30 天
                        ).then((DateTime val) {
                          print(val.year); // 2018-07-12 00:00:00.000

                          int month=val.month;
                          String months="";
                          if(month<=9){
                            months="0"+month.toString();
                          }else{
                            months=month.toString();
                          }
                          int days=val.day;
                          String dayss="";
                          if(days<=9){
                            dayss="0"+days.toString();
                          }else{
                            dayss=days.toString();
                          }
                          String date=val.year.toString()+'-'+months+"-"+dayss;
                          if(this.starttime==null || this.starttime=='') {
                            setState(() {
                              this._endtime.text=date;
                              this.endtime = date;
                            });
                          }else{
                            var startTime = DateTime.parse(this.starttime).millisecondsSinceEpoch;//返回时间戳
                            var endTime = DateTime.parse(date).millisecondsSinceEpoch;//返回时间戳
                            if(endTime>=startTime){//结束时间要大于开始时间
                              setState(() {
                                this._endtime.text=date;
                                this.endtime = date;
                              });
                            }else{
                              showToast("结束日期要大于开始日期！");
                            }
                          }
                        }).catchError((err) {
                          print(err);
                        });
                      },
                    ),
                  ),
                  new Expanded(flex: 2, child: Divider(color: Colors.transparent,)),
                ],
              ),
              Divider(
                height: 20,
                color: Colors.transparent,
              ),
              Row(
                children: <Widget>[
                  new Expanded(flex:2,child: Divider(color: Colors.transparent,)),
                  new Expanded(
                      flex: 20,
                      child: TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: '标题',
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.text,
                        controller: this._title,
                        validator: (String value){
                          return value.length>0?null:"请输入标题";
                        },
                        onSaved: (String value) => this.title=value.trim(),
                      )
                  ),
                  new Expanded(flex:2,child: Divider(color: Colors.transparent,)),
                ],
              ),
              Divider(
                height: 20,
                color: Colors.transparent,
              ),
              Row(
                children: <Widget>[
                  new Expanded(flex:2,child: Divider(color: Colors.transparent,)),
                  new Expanded(
                      flex: 20,
                      child: TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: '备注',
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.text,
                        controller: this._remark,
                        onSaved: (String value) => this.remark=value.trim(),
                      )
                  ),
                  new Expanded(flex:2,child: Divider(color: Colors.transparent,)),
                ],
              ),
              Divider(
                height: 40,
                color: Colors.transparent,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,// 水平方向均匀排列每个元素
                children: <Widget>[
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                  new Column(
                    mainAxisSize: MainAxisSize.min,//垂直方向大小最小化
                    mainAxisAlignment: MainAxisAlignment.start,//垂直方向居中对齐
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 20),//设置右外边距
                        child:  new RaisedButton(
                          onPressed: (){
                            if(_formKey.currentState.validate()){
                              _formKey.currentState.save();
                              //执行保存方法
                              doFrom().then((result){
                                if(result["status"]){
                                  showToast(result["msg"]);
                                  Navigator.pop(context);
                                }else{
                                  showToast(result["msg"]);
                                }
                              });
                            }
                          },
                          color: Colors.blue,
                          child: new Text(
                            '修改',
                            style: new TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  new Column(
                    mainAxisSize: MainAxisSize.min,//垂直方向大小最小化
                    mainAxisAlignment: MainAxisAlignment.center,//垂直方向居中对齐
                    children: <Widget>[
                      new RaisedButton(
                        onPressed: (){
                          //删除弹窗
                          showDialog(
                          context: context,
                          builder: (context) =>
                            AlertWidget(
                            title:"删除",
                            message:"确定删除数据吗？",
                            confirmCallback:(){
                                doDelete();
                              }
                            )
                          );
                        },
                        color: Colors.red,
                        child: new Text(
                          '删除',
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                ],
              )
            ],
          )
      ),
    );
  }

  //保存领导日程
  Future<Map> doFrom() async{
    Response result = await HttpUtil.getInstance(context).post("daily/appFormSave",
        data: {
          "starttime":this.starttime,//开始日期
          "endtime":this.endtime,//结束日期
          "title":this.title,//标题
          "remark":this.remark,//备注
          "id":widget.Id,//id
          "userid":this.info["userid"]//用户id
        });
    return json.decode(result.data);
  }

  @override
  void initState() {
    super.initState();
    //获取数据
    toInfo();
  }

  //根据id获取领导日程数据
  Future<Map> toInfo() async{
    Response response = await HttpUtil.getInstance(context).post("daily/formLoad",data: {
      "id":widget.Id
    });
    var result = json.decode(response.data);
    setState(() {
      this.info = result;
      //初始化数据
      starttime = this.info["starttime"];
      _starttime.text = this.info["starttime"];
      _endtime.text = this.info["endtime"];
      endtime = this.info["endtime"];
      _title.text = this.info["title"];
      _remark.text = this.info["remark"];
    });
  }

  //删除数据
  Future<Map> doDelete() async{
    Response response = await HttpUtil.getInstance(context).post("daily/listDel",data: {
      "id":widget.Id//id
    });
    var result = json.decode(response.data);
    if(result["status"]){
      showToast(result["msg"]);
      Navigator.pop(context);
    }else{
      showToast(result["msg"]);
    }
  }

}

