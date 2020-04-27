//已办流程
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/process/examineProcess/ProcessInfo/LeaveAf.dart';
import 'package:oa/pages/process/examineProcess/ProcessInfo/TaskInfo.dart';
import 'package:oa/pages/process/examineProcess/ProcessInfo/WorkAf.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oa/pages/process/examineProcess/ProcessInfo/VehicleAf.dart';
import 'package:oa/utils/HttpUtil.dart';


class Succee extends StatefulWidget {
  @override
  _Succee createState() => _Succee();
}

class _Succee extends State<Succee> {
  final page = 1;
  final rows = 10;
  List list = new List();

  Widget build(BuildContext context) {
    return ListView(children: buildNews());
  }

  //构建列表
  List<Widget> buildNews() {
    List<Widget> Items = [];
    Items.add(Container(
      margin: EdgeInsets.only(bottom: 4),
    ));
    if (this.list.length > 0) {
      for (int i = 0; i < this.list.length; i++) {
        Items.add(Card(
          color: Color(0xffffffff),
          margin: EdgeInsets.only(top: 1),
          child: Row(children: <Widget>[
            new Expanded(
              child: ListTile(
                title: Text(
                  list[i]["processDefinitionName"],
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                  "申请时间：" + DateTimeUtil.formatDateString(list[i]["startTime"]),
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () {
                  //车辆
                  if (list[i]["startFromKey"] ==
                      "/vehicleapplyrecord/processToForm") {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return VehicleAf(list[i]["businessId"], list[i]["processInstanceId"],taskId: list[i]["taskId"]);
                    }));
                    //办公
                  } else if (list[i]["startFromKey"] ==
                      "/purchaseapply/processToForm") {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return WorkAf(
                          list[i]["businessId"], list[i]["processInstanceId"],
                          taskId: list[i]["taskId"]);
                    }));
                    //请假
                  } else if (list[i]["startFromKey"] ==
                      "/vacationapply/processToForm") {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return LeaveAf(
                          list[i]["businessId"], list[i]["processInstanceId"],
                          taskId: list[i]["taskId"]);
                    }));
                  } else {
                    //公共
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return TaskInfo(
                          list[i]["businessId"], list[i]["processInstanceId"],
                          taskId: list[i]["taskId"]);
                    }));
                  }
                },
              ),
            ),
          ]),
        ));
      }
    } else {
      Items.add(
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/not.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 240, bottom: 10, left: 15, right: 3),
          child: Text(
            '暂无流程',
            style: new TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              letterSpacing: 2.0,
            ),
          ),
        ),
      );
    }

    return Items;
  }

  @override
  void initState() {
    super.initState();
    toList();
  }

  //已办流程
  Future<Map> toList() async {
    Response results = await HttpUtil.getInstance(context)
        .post("appProcess/loadMineDealtProcess", data: {
      "page": this.page,
      "rows": this.rows,
    });
    Map result = json.decode(results.data);
    if (result["total"] > 0) {
      setState(() {
        this.list = result["rows"] as List;
      });
    } else {
      showToast("请稍后尝试!");
    }
  }

}
