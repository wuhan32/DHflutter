import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mini_calendar/model/date_day.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../utils/HttpUtil.dart';

class DailyFormPage extends StatefulWidget{

  DateDay day;
  DailyFormPage(this.day) : super();

  @override
  _DailyFormPageState createState()=> new _DailyFormPageState();
}

class _DailyFormPageState extends State<DailyFormPage>{

  String starttime = "";//开始日期
  String endtime = "";//结束日期
  String title = "";//标题
  String remark = "";//内容

  //通过controller   给输入框默认值
  var _starttime = new TextEditingController();
  var _endtime = new TextEditingController();
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
                          initialDate: DateTime.parse(widget.day.toString()),
                          firstDate: DateTime.parse(widget.day.toString())
                              .subtract(new Duration(days: 3000)), // 减 30 天
                          lastDate: DateTime.parse(widget.day.toString())
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
                          initialDate: DateTime.parse(widget.day.toString()),
                          firstDate: DateTime.parse(widget.day.toString())
                              .subtract(new Duration(days: 3000)), // 减 30 天
                          lastDate: DateTime.parse(widget.day.toString())
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
                        onSaved: (String value) => this.remark=value.trim(),
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
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                  new Expanded(
                      flex: 20,
                      child: new RaisedButton(
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
                          '保存',
                          style: new TextStyle(color: Colors.white),
                        ),
                      )
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
          "starttime":this.starttime,
          "endtime":this.endtime,
          "title":this.title,
          "remark":this.remark
        });
    return json.decode(result.data);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      //初始化数据
      starttime = widget.day.toString();
      _starttime.text = widget.day.toString();
      _endtime.text = widget.day.toString();
      endtime = widget.day.toString();
    });
  }

}

