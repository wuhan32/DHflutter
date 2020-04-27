import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleFeeFormPage.dart';
import 'package:oa/pages/oa/car/CarVehicleFeeInfoPage.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

import 'TrainingPlanInfoPage.dart';

class TrainingPlanListPage extends StatefulWidget {
  @override
  _TrainingPlanListPageState createState() => _TrainingPlanListPageState();
}

class _TrainingPlanListPageState extends State<TrainingPlanListPage> {
  final page = 1;
  final rows = 20;
  List list = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('培训安排'),
          ),
        ),
        body: Container(
          child:
          ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Card(
                color: Color(0xffffffff),
                margin: EdgeInsets.only(top: 1),
                child: Row(children: <Widget>[
                  new Expanded(
                    child: ListTile(
                      leading: new Icon(
                        Icons.open_in_browser,
                        color: Colors.blue,
                      ),
                      title: Text(
                        "培训名称：" +
                          (list[index]["tname"]==null?"":list[index]["tname"]),
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Divider(
                            height: 5.0,
                            color: Colors.transparent,
                          ),
                          Text(
                            "课程类型：" + (list[index]["sysinfotype"]==null?"":list[index]["sysinfotype"]),
                            style: TextStyle(fontSize: 12),
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.transparent,
                          ),
                          Text(
                            "负责人：" + (list[index]["staffid"]==null?"":list[index]["staffid"]),
                            style: TextStyle(fontSize: 12),
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.transparent,
                          ),
                          Text(
                            "开始日期：" + (list[index]["startdate"]==null?"":DateTimeUtil.formatDateString(list[index]["startdate"] as int)),
                            style: TextStyle(fontSize: 12),
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                      trailing: Text(
                          (list[index]["dsysext1"]==null?"":list[index]["dsysext1"]),
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return TrainingPlanInfoPage(list[index]["id"]);
                            })).then((_) {
                          toList();
                        });
                      },
                    ),
                  ),
                ]),
              );
            },
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  //获取培训安排列表数据
  Future<Map> toList() async {
    Response results =
    await HttpUtil.getInstance(context).post("trainingplan/listLoad", data: {
      "page": this.page,
      "rows": this.rows,
    });
    var result = json.decode(results.data);
    if (result["total"] > 0) {
      setState(() {
        this.list = result["rows"] as List;
      });
      print(this.list.length);
    } else {
      showToast("暂无数据!");
    }
  }
}
