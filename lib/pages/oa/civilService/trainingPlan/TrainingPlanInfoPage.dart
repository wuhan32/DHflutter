import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleAssignrecordFromPage.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class TrainingPlanInfoPage extends StatefulWidget {
  final String Id;
  TrainingPlanInfoPage(this.Id) : super();

  @override
  _TrainingPlanInfoPageState createState() =>
      _TrainingPlanInfoPageState();
}

class _TrainingPlanInfoPageState
    extends State<TrainingPlanInfoPage> {
  var Info={};

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('培训安排详情'),
          ),
          actions: <Widget>[],
        ),
        body:
        new ListView(
            children: <Widget>[
                buildInfoItem("培训编号", Info["tno"] == null ? "" : Info["tno"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("培训名称", Info["tname"]== null ? "" : Info["tname"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("课程类型", Info["sysinfotype"]== null ? "" : Info["sysinfotype"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("主办单位", Info["hostunit"]== null ? "" : Info["hostunit"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("开始时间", Info["startdate"]== null ? "" : DateTimeUtil.formatDateString(Info["startdate"] as int)),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("结束时间", Info["enddate"]== null ? "" : DateTimeUtil.formatDateString(Info["enddate"] as int)),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("培训机构", Info["torg"]== null ? "" : Info["torg"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("培训天数", Info["tnumber"]== null ? "" : Info["tnumber"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("培训费用（元）", Info["tmoney"]== null ? "" : Info["tmoney"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("其它费用（元）", Info["otherexpenses"]== null ? "" : Info["otherexpenses"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("负责人", Info["staffid"]== null ? "" : Info["staffid"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("负责人电话", Info["phone"]== null ? "" : Info["phone"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("培训地点", Info["taddress"]== null ? "" : Info["taddress"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("培训范围", Info["tscope"]== null ? "" : Info["tscope"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("备注", Info["remark"]== null ? "" : Info["remark"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("培训内容", Info["tcontent"]== null ? "" : Info["tcontent"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
              ]
        )
    );
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

  //获取培训安排详情
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("trainingplan/appFormLoad", data: {
      "id": widget.Id,
  });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    setState(() {
      this.Info = result;
    });
  }
}
