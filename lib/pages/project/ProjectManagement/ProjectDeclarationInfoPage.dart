import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oa/utils/DateTimeUtil.dart';

import '../../../utils/HttpUtil.dart';

class ProjectDeclarationInfoPage extends StatefulWidget {
  final String Id;

  ProjectDeclarationInfoPage(this.Id) : super();

  @override
  _ProjectDeclarationInfoPageState createState() =>
      _ProjectDeclarationInfoPageState();
}

class _ProjectDeclarationInfoPageState
    extends State<ProjectDeclarationInfoPage> {
  var Info={};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('项目申报'),
          ),
          actions: <Widget>[],
        ),
        body: new ListView(children: <Widget>[
          buildInfoItem("项目名称", Info["project_name"] == null ? "" : Info["project_name"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("项目编号", Info["project_code"]== null ? "" : Info["project_code"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("项目地址", Info["project_area"]== null ? "" : Info["project_area"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          //DateTimeUtil.formatDateString(list[i]["startTime"])
         buildInfoItem("计划开始时间", (Info["plan_start_date"]== null ? "" : DateTimeUtil.formatDateString(Info["plan_start_date"]))),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("计划结束时间",(Info["plan_end_date"] == null ? "" : DateTimeUtil.formatDateString(Info["plan_end_date"]) )),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),

          buildInfoItem("所属区域", Info["subordinate_region"]== null ? "" : Info["subordinate_region"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("工程工期", Info["construction_period"]== null ? "" : Info["construction_period"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("工程量估算", Info["project_estimate"]== null ? "" : Info["project_estimate"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("工程造价", Info["project_cost"]== null ? "" : Info["project_cost"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("预期利润", Info["expected_profit"]== null ? "" : Info["expected_profit"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("项目类型", Info["project_type"]== null ? "" : Info["project_type"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("质量等级", Info["quality_grade"]== null ? "" : Info["quality_grade"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("项目跟踪人", Info["project_tracker"]== null ? "" : Info["project_tracker"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("所属分公司", Info["affiliated_branch"]== null ? "" : Info["affiliated_branch"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("项目状态", Info["project_state"]== null ? "" : Info["project_state"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
        ]));
  }

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

  //获取立项项目数据详情
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("contractProject/formLoad", data: {
      "id": widget.Id,
    });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    setState(() {
      this.Info = result;
    });
  }
}
