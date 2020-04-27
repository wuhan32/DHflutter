import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleAssignrecordFromPage.dart';
import 'package:oktoast/oktoast.dart';

import '../../../utils/HttpUtil.dart';

class CarVehicleAssignrecordInfoPage extends StatefulWidget {
  final String Id;

  CarVehicleAssignrecordInfoPage(this.Id) : super();

  @override
  _CarVehicleAssignrecordInfoPageState createState() =>
      _CarVehicleAssignrecordInfoPageState();
}

class _CarVehicleAssignrecordInfoPageState
    extends State<CarVehicleAssignrecordInfoPage> {
  var Info={};

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('分派详情'),
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
          )
          ,
          Container(
            alignment: Alignment.centerLeft,
            color: Colors.white,
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 3),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RaisedButton(
                          padding:EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                              return CarVehicleAssignrecordFromPage(true,Id:widget.Id);
                            })).then((_){
                              toInfo();
                            });
                          },
                          color: Colors.blue,
                          child: new Text(
                            '修改',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            doDel().then((result) {
                              print(result);
                              if (result["status"]) {
                                showToast(result["msg"]);
                                Navigator.pop(context);
                              } else {
                                showToast(result["msg"]);
                              }
                            });
                          },
                          color: Colors.red,
                          child: new Text(
                            '删除',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
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
  //删除
  Future<Map> doDel() async {
    Response result = await HttpUtil.getInstance(context)
        .post("vehicleassignrecord/listDel", data: {
      "id": widget.Id,
    });
    return json.decode(result.data);
  }
}
