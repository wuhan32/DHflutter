import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../../../utils/HttpUtil.dart';

class CarVehiclereMinderInfoPage extends StatefulWidget {
  final String Id;

  CarVehiclereMinderInfoPage(this.Id) : super();

  @override
  _CarVehiclereMinderInfoPagePageState createState() =>
      _CarVehiclereMinderInfoPagePageState();
}

class _CarVehiclereMinderInfoPagePageState
    extends State<CarVehiclereMinderInfoPage> {
  var Info={};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('车辆预警详情'),
          ),
          actions: <Widget>[],
        ),
        body: new Column(children: <Widget>[
          buildInfoItem("分派编号", Info["applyrecordno"] == null ? "" : Info["applyrecordno"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("用车人", Info["usevehpersonname"]== null ? "" : Info["usevehpersonname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("用车人手机", Info["usevehpersonmobile"]== null ? "" : Info["usevehpersonmobile"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("登记时间", Info["rectime"]== null ? "" : Info["rectime"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("分派车辆", Info["vehiclenumber"]== null ? "" : Info["vehiclenumber"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),

          buildInfoItem("指定驾驶人", Info["drivername"]== null ? "" : Info["drivername"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("临时驾驶人", Info["chsname"]== null ? "" : Info["chsname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("派车开始时间", Info["assignstarttime"]== null ? "" : Info["assignstarttime"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("规定返还时间", Info["fixendtime"]== null ? "" : Info["fixendtime"]),
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

  //获取车辆分派记录
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehicleassignrecord/appFormLoad", data: {
      "id": widget.Id,
    });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    print("分派详情");
    print(result);
    setState(() {
      this.Info = result;
    });
  }
}
