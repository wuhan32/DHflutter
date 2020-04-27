import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleFeeFormPage.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oktoast/oktoast.dart';

import '../../../utils/HttpUtil.dart';

class CarVehicleFeeInfoPage extends StatefulWidget {
  final String Id;
  CarVehicleFeeInfoPage(this.Id) : super();
  @override
  _CarVehicleFeeInfoPageState createState() => _CarVehicleFeeInfoPageState();
}

class _CarVehicleFeeInfoPageState extends State<CarVehicleFeeInfoPage> {
  var Info = {};
  bool itemshow=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('车辆费用详情'),
          ),
          actions: <Widget>[],
        ),
        body: ListView(children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            color: Colors.white,
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 3),
            child: Text(
              '费用信息',
              style: new TextStyle(
                color: Colors.blue,
                fontSize: 16.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
          buildInfoItem("登记人名称",
              Info["feerecpersonname"] == null ? "" : Info["feerecpersonname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem(
              "费用类型", Info["feetypename"] == null ? "" : Info["feetypename"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem(
              "金额（元）", Info["feevalue"] == null ? "" : Info["feevalue"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("费用日期", Info["feedate"] == null ? "" : Info["feedate"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("备注", Info["remark"] == null ? "" : Info["remark"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          Container(
            alignment: Alignment.centerLeft,
            color: Colors.white,
            padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 3),
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
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (BuildContext context) {
                              return CarVehicleFeeFormPage(true,Id: widget.Id,);
                            })).then((_) {
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
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          infoItem()
        ]));
  }

  Widget infoItem(){
    if(!itemshow){
      return Divider(color: Colors.transparent,);
    }else{
      return Column(children: <Widget>[
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 3),
          child: Text(
            '机动车辆保险信息',
            style: new TextStyle(
              color: Colors.blue,
              fontSize: 16.0,
              letterSpacing: 2.0,
            ),
          ),
        ),
        buildInfoItem("被保险人", Info["theinsured"] == null ? "" : Info["theinsured"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("证件号码", Info["theinsurednumber"] == null ? "" : Info["theinsurednumber"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("住址", Info["theinsuredaddress"] == null ? "" : Info["theinsuredaddress"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("联系方式", Info["theinsuredphonenumber"] == null ? "" : Info["theinsuredphonenumber"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("车辆号牌号码", Info["vehiclenumber"] == null ? "" : Info["vehiclenumber"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("车辆厂牌型号", Info["vehiclemodel"] == null ? "" : Info["vehiclemodel"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("车架号", Info["vin"] == null ? "" : Info["vin"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("车辆VIN码", Info["vinnumber"] == null ? "" : Info["vinnumber"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("发动机号", Info["enginenumber"] == null ? "" : Info["enginenumber"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("使用性质", Info["nature"] == null ? "" : Info["nature"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("初次登记日期", Info["registerdate"].toString() == null ? "" :DateTimeUtil.formatDateString(Info["registerdate"])),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("车辆类型", Info["vehicletype"] == null ? "" : Info["vehicletype"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("已使用年限", Info["agelimit"] == null ? "" : Info["agelimit"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("核定载客人数", Info["seatingcapacity"] == null ? "" : Info["seatingcapacity"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("核定载质量", Info["quality"] == null ? "" : Info["quality"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("行驶证车主", Info["travelowner"] == null ? "" : Info["travelowner"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("行驶区域", Info["travelarea"] == null ? "" : Info["travelarea"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("保险期间", Info["insurancetime"] == null ? "" : Info["insurancetime"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("保险合同争议解决方式", Info["solveway"] == null ? "" : Info["solveway"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("保险人公司名称", Info["companyname"] == null ? "" : Info["companyname"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("保险人电话号码", Info["insurancephonenumber"] == null ? "" : Info["insurancephonenumber"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("保险人公司住址", Info["companyaddress"] == null ? "" : Info["companyaddress"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("保险人邮政编码", Info["zipcode"] == null ? "" : Info["zipcode"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("签单日期", Info["writtenpermissiondate"] == null ? "" : Info["writtenpermissiondate"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("核保", Info["underwriting"] == null ? "" : Info["underwriting"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("制单", Info["preparedocument"] == null ? "" : Info["preparedocument"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("经办", Info["handle"] == null ? "" : Info["handle"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("特别约定", Info["specialagreement"] == null ? "" : Info["specialagreement"]),
        Divider(height: 1.0,color: Colors.black12,),
        buildInfoItem("重要提示", Info["hint"] == null ? "" : Info["hint"]),
        Divider(height: 1.0,color: Colors.black12,),
      ],);
    }
  }
  Widget buildInfoItem(String itemName, String itemValue) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(itemName,
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
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

  //获取车辆费用详情记录
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehiclefee/appFormLoad", data: {
      "id": widget.Id,
    });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    print("费用详情");
    print(result);
    setState(() {
      this.Info = result;
      if(Info["feetypename"]=="机动车保险单"){
        itemshow=true;
      }else{
        itemshow=false;
      }
    });
  }

  //删除
  Future<Map> doDel() async {
    Response result = await HttpUtil.getInstance(context)
        .post("vehiclefee/listDel", data: {
      "id": widget.Id,
    });
    return json.decode(result.data);
  }
}
