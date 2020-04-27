import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oa/utils/DateTimeUtil.dart';

import '../../../utils/HttpUtil.dart';

class CompletionInfoPage extends StatefulWidget {
  final String Id;

  CompletionInfoPage(this.Id) : super();

  @override
  _CompletionInfoPageState createState() =>
      _CompletionInfoPageState();
}

class _CompletionInfoPageState
    extends State<CompletionInfoPage> {
  var Info={};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true ,
          title: new Text("完工结算"),
          actions: <Widget>[],
        ),
        body: new ListView(children: <Widget>[
          buildInfoItem("日期", (Info["createdate"] == null ? "" : DateTimeUtil.formatDateString(Info["createdate"]))),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("结算编号", Info["completionno"]== null ? "" : Info["completionno"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("结算名称", Info["completionname"]== null ? "" : Info["completionname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("所属项目", Info["projectname"]== null ? "" : Info["projectname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("合同名称", Info["contractname"]== null ? "" : Info["contractname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("合同金额", Info["contractpice"]== null ? "" : Info["contractpice"].toString()),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("甲方单位", Info["partyaunit"]== null ? "" : Info["partyaunit"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("罚款", Info["fine"]== null ? "" : Info["fine"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("扣款", Info["withhold"]== null ? "" : Info["withhold"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("结算金额", Info["completionpice"]== null ? "" : Info["completionpice"].toString()),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("经办人", Info["informant"]== null ? "" : Info["informant"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("结算说明", Info["remake"]== null ? "" : Info["remake"]),
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
        .post("completion/appFormLoad", data: {
      "id": widget.Id,
    });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    setState(() {
      //this.Info = result["paymentContract"];
      this.Info = result;
      print(result);
    });
  }
}
