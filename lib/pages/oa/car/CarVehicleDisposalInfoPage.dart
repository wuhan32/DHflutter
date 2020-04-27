import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleDisposalFormPage.dart';
import 'package:oktoast/oktoast.dart';

import '../../../utils/HttpUtil.dart';

class CarVehicleDisposalInfoPage extends StatefulWidget {
  final String Id;
  CarVehicleDisposalInfoPage(this.Id) : super();

  @override
  _CarVehicleDisposalInfoPageState createState() =>
      _CarVehicleDisposalInfoPageState();
}

class _CarVehicleDisposalInfoPageState
    extends State<CarVehicleDisposalInfoPage> {
  var Info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('车辆处置详情'),
          ),
          actions: <Widget>[],
        ),
        body: new Column(children: <Widget>[
          buildInfoItem(
              "资产编号", Info["assetnumber"] == null ? Info["assetnumberid"] : Info["assetnumber"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("车牌号码",
              Info["vehiclenumber"] == null ? "" : Info["vehiclenumber"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem(
              "品牌类型", Info["brandtype"] == null ? "" : Info["brandtype"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("登记人名称",
              Info["recpersonname"] == null ? "" : Info["recpersonname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem(
              "处置性质", Info["disstate"] == null ? "" : Info["disstate"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("处置日期", Info["disdate"] == null ? "" : Info["disdate"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("描述", Info["remark"] == null ? "" : Info["remark"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem(
              "处置原因", Info["disreason"] == null ? "" : Info["disreason"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
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
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                              return CarVehicleDisposalFormPage(true,Id:widget.Id);
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
        .post("vehicledisposal/appFormLoad", data: {
      "id": widget.Id,
    });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    print("车辆处置详情");
    print(result);
    if (result != null) {
      setState(() {
        this.Info = result;
      });
    } else {
      showToast("请稍后尝试!");
    }
  }

  //删除
  Future<Map> doDel() async {
    Response result = await HttpUtil.getInstance(context)
        .post("vehicledisposal/listDel", data: {
      "id": widget.Id,
    });
    return json.decode(result.data);
  }
}
