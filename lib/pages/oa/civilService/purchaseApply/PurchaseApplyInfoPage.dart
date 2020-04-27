import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleAssignrecordFromPage.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class PurchaseApplyInfoPage extends StatefulWidget {
  final String Id;
  final bool _isShow;
  PurchaseApplyInfoPage(this.Id,this._isShow) : super();

  @override
  _PurchaseApplyInfoPageState createState() =>
      _PurchaseApplyInfoPageState();
}

class _PurchaseApplyInfoPageState
    extends State<PurchaseApplyInfoPage> {
  var Info={};

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('办公用品申购详情'),
          ),
          actions: <Widget>[],
        ),
        body: new Column(children: <Widget>[
          buildInfoItem("申请人", Info["proposer"] == null ? "" : Info["proposer"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("申请部门", Info["applyorg"]== null ? "" : Info["applyorg"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("申请日期", Info["applydate"]== null ? "" : Info["applydate"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("更新时间", Info["updatetime"]== null ? "" : Info["updatetime"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("用品名称", Info["cname"]== null ? "" : Info["cname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),

          buildInfoItem("供应商名称", Info["suppliername"]== null ? "" : Info["suppliername"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("品牌型号", Info["models"]== null ? "" : Info["models"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("单位", Info["unitname"]== null ? "" : Info["unitname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("单价（元）", Info["price"]== null ? "" : Info["price"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("数量", Info["number"]== null ? "" : Info["number"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("用途及说明", Info["remar"]== null ? "" : Info["remar"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          stockButton(),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
        ]));
  }

  //构建组件
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

  //获取办公用品申购详情
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("purchaseapply/appFormLoad", data: {
      "id": widget.Id,
  });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    setState(() {
      this.Info = result;
    });
  }

  //入库按钮
  Widget stockButton(){
    if(!widget._isShow){
      return Container(child: Text(""),);
    }else{
      return Row(
        children: <Widget>[
          new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          new Expanded(
              flex: 20,
              child: new RaisedButton(
                onPressed: (){
                  doStock().then((result){
                    if(result["status"]){
                      showToast(result["msg"]);
                      Navigator.pop(context);
                    }else{
                      showToast(result["msg"]);
                    }
                  });
                },
                color: Colors.blue,
                child: new Text(
                  '入库',
                  style: new TextStyle(color: Colors.white),
                ),
              )
          ),
          new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
        ],
      );
    }
  }
  //入库操作
  Future<Map> doStock() async {
    Response result = await HttpUtil.getInstance(context)
        .post("purchaseapply/updateStatus", data: {
      "id": widget.Id,
    });
    return json.decode(result.data);
  }
}
