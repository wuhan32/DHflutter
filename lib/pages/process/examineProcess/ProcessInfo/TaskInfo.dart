// 公共详情

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class TaskInfo extends StatefulWidget {
  var businessId = "";
  var processInstanceId = "";
  int identification = null;
  var taskId = "";

  TaskInfo(this.businessId, this.processInstanceId,
      {this.identification, this.taskId})
      : super();
  @override
  _VehicleAf createState() => _VehicleAf();
}

class _VehicleAf extends State<TaskInfo> {
  //表头
  String header = "";
  //公共表单详情
  Map flowInfo = {};
  //申请表单
  List taskInfo = [];
  //审批意见
  List historyActivitys = [];
  TextEditingController phoneController = TextEditingController();

  //动态审批表单
  var taskCommonFrom = null;
//审批表单提交
  Map<String,TextEditingController> controllers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(header),
          ),
          actions: <Widget>[IconButtonItem()],
        ),
        body: Column(children: <Widget>[
          Expanded(
            flex: 5,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child: Text("表单详情",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                )),
                          ),
                          buildInfoItem(
                              "申请人",
                              flowInfo["startUser"] == null
                                  ? ""
                                  : flowInfo["startUser"]),
                          Divider(
                            height: 1.0,
                            color: Colors.black12,
                          ),
                          buildInfoItem(
                              "联系电话",
                              flowInfo["phone"] == null
                                  ? ""
                                  : flowInfo["phone"]),
                          Divider(
                            height: 1.0,
                            color: Colors.black12,
                          ),
                          buildInfoItem(
                              "所属部门",
                              flowInfo["department"] == null
                                  ? ""
                                  : flowInfo["department"]),
                          Divider(
                            height: 1.0,
                            color: Colors.black12,
                          ),
                          buildInfoItem("申请流程", header == null ? "" : header),
                          Divider(
                            height: 1.0,
                            color: Colors.black12,
                          ),
                          buildInfoItem(
                              "开始时间",
                              flowInfo["startTime"] == null
                                  ? ""
                                  : DateTimeUtil.formatDateString(
                                      flowInfo["startTime"])),
                          Divider(
                            height: 1.0,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child:Column(
                              children: <Widget>[
                                Text(  this.taskInfo.length >0   ?  "申请详情" : "",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.blue,
                                    )
                                ),
                                buildNews(),
                              ],
                            )
                          ),
                        ],
                      ),
                    ),
                    historyActivitysItme()
                  ],
                )
              ],
            ),
          ),
        ]));
  }

  //构建列表
  buildNews() {
    Widget content;
    List<Widget> items = [];
    for (int i = 0; i < taskInfo.length; i++) {
      var name = taskInfo[i]["name"];
      var id = taskInfo[i]["id"];
      items.add(Column(
        children: <Widget>[
          Container(
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
                        Text(name,
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
                        id,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      )),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black12,
          )
        ],
      )
      );
    }
    content = new Column(
        children: items
    );
    return content;
  }



  //公共流程
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

  //审批组件
  Widget historyActivitysItme() {
    if (this.historyActivitys.isNotEmpty) {
      return Container(
          alignment: Alignment.centerLeft,
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 3),
          child:
          Column(
            children: <Widget>[
              Text(   "审批详情",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                  ) ),
              historyActivitysInfo(),
            ],
          )
      );
    }else{
      return Container(
        child: Text(""),
      );
    }
  }

  //审批详情
  Widget historyActivitysInfo() {
    List<Widget> items = [];
    Widget content;
    for (int i = 0; i < this.historyActivitys.length; i++) {
      var task = historyActivitys[i]["taskComments"];
      for (int j = 0; j < task.length; j++) {
        items.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Container(
                margin:EdgeInsets.only(top:5,bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        historyActivitys[i]["activityName"] +
                            "---" +
                            historyActivitys[i]["actionUser"],
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        )),
                    Container(
                      margin:EdgeInsets.only(top:5),
                      child: Text( "审批意见：" + task[j]["fullMessage"],
                          style: TextStyle(
                            fontSize: 12,
                          )
                      ),
                    )

                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                DateTimeUtil.formatDateTimeString(task[j]["time"]).toString(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            )
          ],
        ));
      }
    }
    content = new Column(
        children: items
    );
    return content;
  }


  //审批弹框
  Widget IconButtonItem() {
    int _value = 1;
    if (widget.identification == 2) {
      return IconButton(
        icon: Icon(Icons.assignment_turned_in),
        tooltip: "审批",
        onPressed: () {
          showDialog<Null>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('审批意见',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      buildfroms(),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: '请输入审批意见',
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  CupertinoButton(
                    child: Text('确定'),
                    onPressed: () {
                      affirmExamine();
                    },
                  ),
                  CupertinoButton(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          ).then((val) {
            print(val);
          });
        },
      );
    } else {
      return IconButton(
          icon: Icon(Icons.cached),
          tooltip: "刷新",
          onPressed: () {
            toInfo();
            showToast("刷新成功");
          });
    }
  }

  @override
  void initState() {
    super.initState();
    toInfo();
    getapprovalForm();
  }

  //审批请求
  Future<Map> affirmExamine() async {
    Map paras={};
    controllers.forEach((String flieName,TextEditingController filedController){
      paras[flieName]=filedController.text;
    });
    var url = "appProcess/completeTask?taskId=" + widget.taskId + "&comment=" + phoneController.text;
    if(phoneController.text  == "") {
      showToast("审批意见不能为空");
    }else {
      Response  results = await HttpUtil.getInstance(context)
          .post(
          url,
          plainData: json.encode(paras),
          options:Options(contentType:Headers.jsonContentType)
      );
      var res = json.decode(results.data);
      showToast(res["msg"]);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

// 公共页面
  Future<Map> toInfo() async {
    var res;
    Response results = await HttpUtil.getInstance(context).post(
        "appProcess/loadHisProcessDetail",
        data: {"processInstanceId": widget.processInstanceId});
    var result = json.decode(results.data);
    setState(() {
      this.header = result["data"]["process"]["processDefinitionName"];
      this.flowInfo = result["data"]["startFrom"];
      this.taskInfo = result["data"]["startFrom"]["formProperties"];
      res = result["data"]["historyActivitys"];
      this.historyActivitys = res;
    });
  }

//审批表单
  buildfroms() {
    Widget content;
    List<Widget> items = [];
    if(this.taskCommonFrom != []) {
      for (int i = 0; i < taskCommonFrom.length; i++) {
        if(taskCommonFrom[i]["type"]["name"] == "enum") {
        }else {
          var name = taskCommonFrom[i]["name"];
          TextEditingController controller= new TextEditingController();
          controllers[taskCommonFrom[i]["id"]]=controller;
          items.add(Column(
            children: <Widget>[
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: name,
                ),
              ),
            ],
          )
          );
        }
      }
      content = new Column(
          children: items
      );
    }
    return content;

  }

// 审批表单详情
  Future<Map> getapprovalForm() async {
    var res;
    Response results = await HttpUtil.getInstance(context).post(
        "appProcess/loadTaskCompleteData",
        data: {"taskId": widget.taskId});
    var result = json.decode(results.data);
    setState(() {
      res = result["data"]["taskFromProperties"];
      this.taskCommonFrom = res;
      print(this.taskCommonFrom);
    });
  }
}
