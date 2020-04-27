import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleAssignrecordFromPage.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class SuppliesApplyInfoPage extends StatefulWidget {
  final String Id;
  SuppliesApplyInfoPage(this.Id) : super();

  @override
  _SuppliesApplyInfoPageState createState() =>
      _SuppliesApplyInfoPageState();
}

class _SuppliesApplyInfoPageState
    extends State<SuppliesApplyInfoPage> {
  var Info={};

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('办公用品申领详情'),
          ),
          actions: <Widget>[],
        ),
        body: new Column(children: <Widget>[
          buildInfoItem("物资名称", Info["pname"] == null ? "" : Info["pname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("物资数量", Info["stockcount"]== null ? "" : Info["stockcount"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("申请部门", Info["applyorg"]== null ? "" : Info["applyorg"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("申请人", Info["proposer"]== null ? "" : Info["proposer"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("申请日期", Info["applydate"]== null ? "" : DateTimeUtil.formatDateString(Info["applydate"])),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),

          buildInfoItem("申领数量", Info["number"]== null ? "" : Info["number"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("用途及说明", Info["remar"]== null ? "" : Info["remar"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
        ]));
  }

  //构建组件
  Widget buildInfoItem(String itemName, String itemValue) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(itemName,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  itemValue,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                )),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    toInfo();
  }

  //获取办公用品申领详情
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("suppliesapply/appFormLoad", data: {
      "id": widget.Id,
  });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    setState(() {
      this.Info = result;
    });
  }
}
