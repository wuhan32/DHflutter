import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import '../../../utils/HttpUtil.dart';

class ScheduleProjectInfoPage extends StatefulWidget {
  final String Id;

  ScheduleProjectInfoPage(this.Id) : super();

  @override
  _ScheduleProjectInfoPageState createState() =>
      _ScheduleProjectInfoPageState();
}

class _ScheduleProjectInfoPageState
    extends State<ScheduleProjectInfoPage> {
  final page = 1;//当前页
  final rows = 20;//显示条数
  List list = new List();
  var Info={};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('进度款详情'),
          ),
          actions: <Widget>[],
        ),
        body: new ListView(children: <Widget>[
          Divider(height: 10, color: Colors.transparent),
          Container(
            //alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 0, bottom: 10, left: 15, right: 3),
            child: Text(
              '基本信息',
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.green,
                fontSize: 16.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
            buildInfoItem("日期", (Info["createdate"]== null ? "" : DateTimeUtil.formatDateString(Info["createdate"]))),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("申报编号", Info["declareno"]== null ? "" : Info["declareno"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("申报名称", Info["declarename"]== null ? "" : Info["declarename"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),

          buildInfoItem("填报人", Info["informant"]== null ? "" : Info["informant"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("所属项目", Info["proname"]== null ? "" : Info["proname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("合同名称", Info["contractname"]== null ? "" : Info["contractname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("合同金额", Info["contractpice"]== null ? "" : Info["contractpice"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("甲方单位", Info["partaunitid"]== null ? "" : Info["partaunitid"]),
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
          buildInfoItem("批复金额", Info["declarepice"]== null ? "" : Info["declarepice"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("批复金额（大写）", Info["declarepicebig"]== null ? "" : Info["declarepicebig"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("结算类型", Info["name"]== null ? "" : Info["name"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("备注", Info["remark"]== null ? "" : Info["remark"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          declareTheDetailsItme(),//申报内容详情
         ])
    );
  }
//表单页面加载
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
    toList();
  }
//列表页面加载
  Widget detailed() {
    List<Widget> Items = [];
    Widget content;
    Items.add(Container(
      margin: EdgeInsets.only(bottom: 4),
    ));
    for (int i = 0; i < this.list.length; i++) {
      Items.add(
          Card(
            color: Color(0xffffffff),
            margin: EdgeInsets.only(top: 1),
            child: Row(
                children: <Widget>[
                  new Expanded(
                    child: ListTile(
                     // leading: new Icon(Icons.assignment,color: Colors.blue,),
                      title: Text((list[i]["listCode"]==null?"未定义":list[i]["listCode"])+"             "+(list[i]["listingSubtitle"]==null ? "未填写":list[i]["listingSubtitle"]), style: TextStyle(fontSize: 15),),
                      subtitle:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Divider(height: 5.0,color: Colors.transparent,),
                          Text("单位："+(list[i]["unit"]==null ? "未填写":list[i]["unit"])+"             "+"合同数量："+(list[i]["quantities"]==null ? "未填写":list[i]["quantities"].toString()),style: TextStyle(fontSize: 12),),
                          Divider(height: 5.0,color: Colors.transparent,),
                          Text("综合单价："+(list[i]["comprehensivePrice"]==null ? "未填写":list[i]["comprehensivePrice"].toString())+"             "+"合计："+(list[i]["numberbox"]==null ? "未填写":list[i]["numberbox"].toString()),style: TextStyle(fontSize: 12),),
                          Divider(height: 5.0,color: Colors.transparent,),
                          Text("本期申报量："+(list[i]["currentDeclaration"]==null ? "未填写":list[i]["currentDeclaration"].toString())+"             "+"本期核准量："+(list[i]["thisApproval"]==null ? "未填写":list[i]["thisApproval"].toString()),style: TextStyle(fontSize: 12),),
                          Divider(height: 5.0,color: Colors.transparent,),
                          Text("结算小计："+(list[i]["subtotal"]==null ? "未填写":list[i]["subtotal"].toString())+"             "+"备注："+(list[i]["remark"]==null ? "未填写":list[i]["remark"].toString()),style: TextStyle(fontSize: 12),),
                          Divider(height: 5.0,color: Colors.transparent,),
                        ],
                      ),
                    ),
                  ),
                ]),
          )
      );
    }
    return   content = new Column(children: Items);
  }

  Widget declareTheDetailsItme() {
      return Container(
          alignment: Alignment.centerLeft,
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 3),
          child: Column(
            children: <Widget>[
              Text("申报内容",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.green,
                  )),
              detailed(),
            ],
          ));
  }

  //获取立项项目数据详情
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("scheduleProject/appFormLoad", data: {
      "id": widget.Id,
    });
    var result = json.decode(results.data);
    setState(() {
      this.Info = result["incomeContract"];
    });
  }
  Future<Map> toList() async {
    print("id:" + widget.Id);
    Response results = await HttpUtil.getInstance(context)
        .post("declareContent/listLoadById", data: {
      "page": this.page,
      "rows": this.rows,
      "incomeContractId":widget.Id,
    });
    var result = json.decode(results.data);
      //showToast("获取数据成功");
      setState(() {
        this.list = result["rows"] as List;
      });
  }
}
