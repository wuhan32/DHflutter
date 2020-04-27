import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oa/utils/DateTimeUtil.dart';

import '../../../utils/HttpUtil.dart';

class ProceedsContractInfoPage extends StatefulWidget {
  final String Id;

  ProceedsContractInfoPage(this.Id) : super();

  @override
  _ProceedsContractInfoPageState createState() =>
      _ProceedsContractInfoPageState();
}

class _ProceedsContractInfoPageState
    extends State<ProceedsContractInfoPage> {
  var Info={};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('合同收款'),
          ),
          actions: <Widget>[],
        ),
        body: new ListView(children: <Widget>[
            buildInfoItem("日期", (Info["thedate"]== null ? "" : DateTimeUtil.formatDateString(Info["thedate"]))),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("收款编号", Info["proceedscode"]== null ? "" : Info["proceedscode"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("收款名称", Info["proceedsname"]== null ? "" : Info["proceedsname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),

          buildInfoItem("合同金额", Info["contractmoney"]== null ? "" : Info["contractmoney"].toString()),
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
          buildInfoItem("甲方单位", Info["partaunitid"]== null ? "" : Info["partaunitid"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("收款方式", Info["proceedstypename"]== null ? "" : Info["proceedstypename"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("收款金额", Info["bankaccount"]== null ? "" : Info["bankaccount"].toString()),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("扣款", Info["deduct"]== null ? "" : Info["deduct"].toString()),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("罚款", Info["fine"]== null ? "" : Info["fine"].toString()),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("账号信息", Info["accountinformation"]== null ? "" : Info["accountinformation"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("银行账户", Info["bankaccount"]== null ? "" : Info["bankaccount"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("填报人", Info["informant"]== null ? "" : Info["informant"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("备注", Info["remark"]== null ? "" : Info["remark"]),
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
        .post("proceedsContract/appFormLoad", data: {
      "id": widget.Id,
    });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    setState(() {
      this.Info = result["proceedsContract"];
      print(result);
    });
  }
}
