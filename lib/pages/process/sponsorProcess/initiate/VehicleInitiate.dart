//车辆发起
import 'dart:convert';

import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class VehicleInitiate extends StatefulWidget {
  @override
  _VehicleInitiate createState() => _VehicleInitiate();
}

class _VehicleInitiate extends State<VehicleInitiate> {
  //当天时间
  DateTime nowTime = new DateTime.now();
  //计划开始时间
  var startTime;
  var _startTime = TextEditingController();
  //计划结束时间
  var finishTime;
  var _finishTime = TextEditingController();
  //市内
  String city;
  //长途
  String coach;

  //市内/长途传值后台
  String _newValue;


  //申请人
  TextEditingController vehicleName = TextEditingController();
  //电话
  TextEditingController vehiclePhone = TextEditingController();
  //用车人名称
  List playvehicleName = [];
  //用车人电话
  TextEditingController playvehiclePhoen = TextEditingController();
  //人数
  TextEditingController vehicleOrder = TextEditingController();
  //上客地址
  TextEditingController playvehicleStartSite = TextEditingController();
  //到达地址
  TextEditingController playvehicleFinishSite = TextEditingController();
  //用途
  TextEditingController vehicleUse = TextEditingController();
  //姓名
  TextEditingController Bossname = TextEditingController();
  //事由
  TextEditingController playvehicleOrigin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("车辆申请流程表单"),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.autorenew),
            tooltip: "刷新",
            onPressed: () {
              initState();
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              controller: vehicleName,
              textAlign: TextAlign.end,
              //onChanged:(value)=>this.userInfo.chsname=value.trim(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, right: 30),
                hintText: "大恒用户",
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "申请人",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              controller: vehiclePhone,
              textAlign: TextAlign.end,
              //onChanged:(value)=>this.userInfo.chsname=value.trim(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, right: 30),
                hintText: "10086",
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "联系电话",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xff999999)))),
            child: Row(
              children: <Widget>[
                Text(
                  "用车人名称",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 22),
                ),
                Container(
                  width: 150,
                  margin: EdgeInsets.only(left:80),
                  child:DropdownButton(
                      icon: Icon(Icons.arrow_drop_down), iconSize: 40, iconEnabledColor: Colors.blueAccent,
                      hint: Text('用车人名称'), isExpanded: true, underline: Container(height: 0,),
                      items: [
                        DropdownMenuItem(
                          child: Text('123123'),
                       ),
                        DropdownMenuItem(
                          child: Text('123123'),
                           ),
                        DropdownMenuItem(
                          child: Text('123123'),
                            )
                      ],
                      onChanged:(value) {})
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              controller: playvehiclePhoen,
              textAlign: TextAlign.end,
              //onChanged:(value)=>this.userInfo.chsname=value.trim(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, right: 30),
                hintText: "申请人",
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "用车人电话",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              controller: vehicleOrder,
              textAlign: TextAlign.end,
              //onChanged:(value)=>this.userInfo.chsname=value.trim(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, right: 30),
                hintText: "申请人",
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "人数",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              controller: playvehicleStartSite,
              textAlign: TextAlign.end,
              //onChanged:(value)=>this.userInfo.chsname=value.trim(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, right: 30),
                hintText: "申请人",
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "上客地址",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              controller: playvehicleFinishSite,
              textAlign: TextAlign.end,
              //onChanged:(value)=>this.userInfo.chsname=value.trim(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, right: 30),
                hintText: "申请人",
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "到达地址",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xff999999)))),
            child: Row(
              children: <Widget>[
                Text(
                  "市内/长途",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 22),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    value: this.city,
                    title: Text('市内'),
                    groupValue: _newValue,
                    onChanged: (value) {
                      setState(() {
                        _newValue = value;
                        print(this._newValue);
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    value: this.coach,
                    title: Text('长途'),
                    groupValue: _newValue,
                    onChanged: (value) {
                      setState(() {
                        _newValue = value;
                        print(_newValue);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              controller: vehicleUse,
              textAlign: TextAlign.end,
              //onChanged:(value)=>this.userInfo.chsname=value.trim(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, right: 30),
                hintText: "申请人",
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "用途",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              controller: Bossname,
              textAlign: TextAlign.end,
              //onChanged:(value)=>this.userInfo.chsname=value.trim(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, right: 30),
                hintText: "申请人",
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "姓名",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xff999999)))),
            child: Row(
              children: <Widget>[
                Text(
                  "用车事由",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 22),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              onTap: () {
                // 调用函数打开
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate:
                      DateTime.now().subtract(Duration(days: 30)), // 减 30 天
                  lastDate: DateTime.now().add(Duration(days: 30)), // 加 30 天
                ).then((DateTime val11) {
                  setState(() {
                    this.startTime = val11;
                    setState(() {
                      this._startTime.text = DateTimeUtil.formatDateString(
                          val11.millisecondsSinceEpoch);
                      this.startTime = DateTimeUtil.formatDateString(
                          val11.millisecondsSinceEpoch);
                    });
                  });
                }).catchError((err) {
                  print(err);
                });
              },
              controller: _startTime,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, right: 30),
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "计划开始时间",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextField(
              onTap: () {
                // 调用函数打开
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate:
                      DateTime.now().subtract(Duration(days: 30)), // 减 30 天
                  lastDate: DateTime.now().add(Duration(days: 30)), // 加 30 天
                ).then((DateTime val11) {
                  setState(() {
                    this.finishTime = val11;
                    setState(() {
                      this._finishTime.text = DateTimeUtil.formatDateString(
                          val11.millisecondsSinceEpoch);
                      this.finishTime = DateTimeUtil.formatDateString(
                          val11.millisecondsSinceEpoch);
                    });
                  });
                }).catchError((err) {
                  print(err);
                });
              },
              controller: _finishTime,
              textAlign: TextAlign.end,
              //onChanged:(value)=>this.userInfo.chsname=value.trim(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, right: 30),
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "计划归还时间",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTime.text = (nowTime.year).toString() +
        "-" +
        (nowTime.month).toString() +
        "-" +
        (nowTime.day).toString();
    _finishTime.text = (nowTime.year).toString() +
        "-" +
        (nowTime.month).toString() +
        "-" +
        (nowTime.day + 2).toString();
    playvehicleNameInfo();
    vehicleCityOrLongInfo();
  }


//用车人名称
  Future<Map> playvehicleNameInfo() async {
    Response results =
        await HttpUtil.getInstance(context).get("approveDocument/getuserById");
    var result = json.decode(results.data);
    var res = result["rows"];
    if (result["total"] > 0) {
      setState(() {
        print("用车人名称");
        this.playvehicleName =res;
          print(this.playvehicleName);
      });
    } else {
      showToast("请稍后尝试!");
    }
  }

  //市内/长途
  Future<Map> vehicleCityOrLongInfo() async {
    String type = "business";
    String codeInfo = "cp1555569199587";
    String useCodeInfo = "cp1557392842131";

    //获取市内/长途数据字典
    Response results = await HttpUtil.getInstance(context).post(
        "/appContract/listsystems",
        data: {"type": type, "code": codeInfo});
    var result = json.decode(results.data);
    var res = result["rows"];
//用途
    Response useresults = await HttpUtil.getInstance(context).post(
        "/appContract/listsystems",
        data: {"type": type, "code": useCodeInfo});
    var useresult = json.decode(useresults.data);
    var useres = useresult["rows"];
    //print(useres);
//    if (useres["total"] > 0) {
//      setState(() {
//
//      });
//    } else {
//      showToast("请稍后尝试!");
//    }
    if (result["total"] > 0) {
      setState(() {
        this.city = res[0]["id"];
        this.coach = res[1]["id"];
      });
    } else {
      showToast("请稍后尝试!");
    }
  }



}

