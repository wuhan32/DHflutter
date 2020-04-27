import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleDrivereCordInfoMapPage.dart';
import 'package:oa/utils/Constants.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/HttpUtil.dart';

class CarVehicleDrivereCordInfoPage extends StatefulWidget {
  final String Id;

  CarVehicleDrivereCordInfoPage(this.Id) : super();

  @override
  _CarVehicleDrivereCordInfoPageState createState() =>
      _CarVehicleDrivereCordInfoPageState();
}

class _CarVehicleDrivereCordInfoPageState
    extends State<CarVehicleDrivereCordInfoPage> {
  WebViewController _controller;
  String _title = "webview";
  Map Info={};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('行驶记录详情'),
          ),
          actions: <Widget>[],
        ),
        body:ListView(children: <Widget>[
          buildInfoItem("用车人", Info["usevehpersonname"] == null ? "" : Info["usevehpersonname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("分派车辆", Info["vehiclenumber"]== null ? "" : Info["vehiclenumber"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("行驶里程（KM）", Info["mileage"]== null ? "" : Info["mileage"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("油价（元/升）", Info["oilprice"]== null ? "" : Info["oilprice"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("总费用", Info["usefee"]== null ? "" : Info["usefee"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),

          buildInfoItem("计划还车时间",Info["oldendtime"].toString()!=null?DateTimeUtil.formatDateString(Info["oldendtime"]):null ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("临时驾驶人", Info["chsname"]== null ? "" : Info["chsname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("实际还车时间", Info["returntime"]== null ? "" : Info["returntime"]),
          Divider(
            height: 10.0,
            color: Colors.black12,
          ),
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 3),
            child: Text(
              '行驶轨迹图',
              style: new TextStyle(
                color: Colors.blue,
                fontSize: 16.0,
                letterSpacing: 2.0,
              ),

            ),

          ),
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 3),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return CarVehicleDrivereCordInfoMapPage();
              }));
              },
              color: Colors.blue,
              child: new Text(
                '点击查看轨迹',
                style: TextStyle(color: Colors.white),
              ),
            )

          ),
      WebView(
        initialUrl: "https://www.baidu.com/",
        //JS执行模式 是否允许JS执行
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        ),
        ]));
  }
  Widget map(){
    return WebView(
      initialUrl: "https://flutterchina.club/",
      //JS执行模式 是否允许JS执行
      javascriptMode: JavascriptMode.unrestricted,
    );
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

  //获取车辆行驶记录详情
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehicledriverecord/appFormLoad", data: {
      "id": widget.Id,
    });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    print("车辆行驶记录详情");
    print(result);
    setState(() {
      this.Info = result;
    });
  }
}
