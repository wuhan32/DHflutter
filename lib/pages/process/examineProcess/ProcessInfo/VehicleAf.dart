// 车辆申请详情
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oa/utils/DateTimeUtil.dart';

class VehicleAf extends StatefulWidget {
  var businessId = "";
  var processInstanceId = "";
  int identification = null;
  var taskId = "";

  VehicleAf(this.businessId, this.processInstanceId,
      {this.identification, this.taskId})
      : super();

  @override
  _VehicleAf createState() => _VehicleAf();
}

class _VehicleAf extends State<VehicleAf> {
  Map toInfoInfo = {};
  Map examineInfo = {};
  //表头
  String header = "";
  //公共表单详情
  Map flowInfo = {};

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
              child: Text('车辆申请'),
            ),
            actions: <Widget>[IconButtonItem()]),
        body: ListView(children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text("流程详情",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
                      )),
                ),
                buildInfoItem("申请人",
                    flowInfo["startUser"] == null ? "" : flowInfo["startUser"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "联系电话", flowInfo["phone"] == null ? "" : flowInfo["phone"]),
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
                        : DateTimeUtil.formatDateString(flowInfo["startTime"])),
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
                  child: Text("申请详情",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
                      )),
                ),
                buildInfoItem(
                    "申请编号",
                    toInfoInfo["applyrecordno"] == null
                        ? ""
                        : toInfoInfo["applyrecordno"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "申请人名称",
                    toInfoInfo["appvehpersonname"] == null
                        ? ""
                        : toInfoInfo["appvehpersonname"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "申请人电话",
                    toInfoInfo["appphonenumber"] == null
                        ? ""
                        : toInfoInfo["appphonenumber"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "用车人名称",
                    toInfoInfo["usevehpersonname"] == null
                        ? ""
                        : toInfoInfo["usevehpersonname"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "用车人电话",
                    toInfoInfo["usevehpersonphone"] == null
                        ? ""
                        : toInfoInfo["usevehpersonphone"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "人数",
                    toInfoInfo["personnum"] == null
                        ? ""
                        : toInfoInfo["personnum"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem("上客地址",
                    toInfoInfo["toplace"] == null ? "" : toInfoInfo["toplace"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "到达地址",
                    toInfoInfo["toAddress"] == null
                        ? ""
                        : toInfoInfo["toAddress"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "市内/长途",
                    toInfoInfo["distancetype"] == null
                        ? ""
                        : toInfoInfo["distancetype"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "用途",
                    toInfoInfo["usevehtype"] == null
                        ? ""
                        : toInfoInfo["usevehtype"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "用车事由",
                    toInfoInfo["usevehreason"] == null
                        ? ""
                        : toInfoInfo["usevehreason"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "计划开始时间",
                    toInfoInfo["appstarttime"] == null
                        ? ""
                        : toInfoInfo["appstarttime"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "计划归还时间",
                    toInfoInfo["appendtime"] == null
                        ? ""
                        : toInfoInfo["appendtime"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
                buildInfoItem(
                    "实际归还时间",
                    toInfoInfo["returnTime"] == null
                        ? ""
                        : toInfoInfo["returnTime"]),
                Divider(
                  height: 1.0,
                  color: Colors.black12,
                ),
              ],
            ),
          ),
          historyActivitysItme()
        ]));
  }

//车辆申请详情列表
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
    if (this.historyActivitys != null) {
      return Container(
          alignment: Alignment.centerLeft,
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 3),
          child: Column(
            children: <Widget>[
              Text("审批详情",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                  )),
              historyActivitysInfo(),
            ],
          ));
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
                margin: EdgeInsets.only(top: 5, bottom: 5),
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
                      margin: EdgeInsets.only(top: 5),
                      child: Text("审批意见：" + task[j]["fullMessage"],
                          style: TextStyle(
                            fontSize: 12,
                          )),
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
    content = new Column(children: items);
    return content;
  }

  @override
  void initState() {
    toInfo();
    toInfoVe();
    getapprovalForm();
    super.initState();
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

  //审批弹框
  Widget IconButtonItem() {
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
                      Column(
                        children: <Widget>[
                          buildfroms(),
                          TextField(
                            controller: phoneController,
                            decoration: InputDecoration(labelText: '请输入审批意见',
                            ),
                          ),
                        ],
                      )


                    ],
                  ),
                ),
                actions: <Widget>[
                  CupertinoButton(
                    child: Text('同意'),
                    onPressed: () {
                      affirmExamine();
                    },
                  ),
                  CupertinoButton(
                    child: Text("不同意"),
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
            toInfoVe();
            showToast("刷新成功");
          });
    }
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

  //车辆流程详情
  Future<Map> toInfoVe() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehicleapplyrecord/formLoad", data: {"id": widget.businessId});
    var result = json.decode(results.data);
    setState(() {
      this.toInfoInfo = result;
    });
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
      res = result["data"]["historyActivitys"];
      this.historyActivitys = res;
    });
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
    });
  }
}

