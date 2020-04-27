import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import '../../../utils/HttpUtil.dart';

class IncomeContracInfoPage extends StatefulWidget {
  final String Id;

  IncomeContracInfoPage(this.Id) : super();

  @override
  _IncomeContracInfoPageState createState() =>
      _IncomeContracInfoPageState();
}

class _IncomeContracInfoPageState
    extends State<IncomeContracInfoPage> {
  final page = 1;//当前页
  final rows = 20;//显示条数
  List list = new List();
  var Info={};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('收入合同'),
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
       /*   buildInfoItem("日期", (Info["theDate"]== null ? "" : DateTimeUtil.formatDateString(Info["theDate"]))),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),*/
          buildInfoItem("合同编号", Info["contractcode"]== null ? "" : Info["contractcode"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("合同名称", Info["contractname"]== null ? "" : Info["contractname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),

          buildInfoItem("合同类型", Info["contractname"]== null ? "" : Info["contractname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("所属项目", Info["projectname"]== null ? "" : Info["projectname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("开始日期", (Info["startdate"]== null ? "" : DateTimeUtil.formatDateString(Info["startdate"]))),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("结束日期",(Info["enddate"] == null ? "" : DateTimeUtil.formatDateString(Info["enddate"]) )),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("合同金额", Info["contractmoney"]== null ? "" : Info["contractmoney"].toString()),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
         /* buildInfoItem("金额(大写)", Info["contractchmoney"]== null ? "" : Info["contractchmoney"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),*/
          buildInfoItem("甲方单位", Info["partaunitid"]== null ? "" : Info["partaunitid"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("乙方单位", Info["partbunitid"]== null ? "" : Info["partbunitid"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("签订人", Info["tosign"]== null ? "" : Info["tosign"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("结算方式", Info["settleaccountsname"]== null ? "" : Info["settleaccountsname"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("预收款", Info["advancesreceived"]== null ? "" : Info["advancesreceived"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("保证金", Info["cashdeposit"]== null ? "" : Info["cashdeposit"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("付款方式", Info["paytypename"]== null ? "" : Info["paytypename"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("收款条件", Info["collectionterms"]== null ? "" : Info["collectionterms"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("主要条款", Info["mainclause"]== null ? "" : Info["mainclause"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          buildInfoItem("备注", Info["remark"]== null ? "" : Info["remark"]),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),

          //
          Container(
            //alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 0, bottom: 10, left: 15, right: 3),
            child: Text(
              '工程量清单',
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Colors.green,
                fontSize: 16.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
          detailed() ,])
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
                        leading: new Icon(Icons.assignment,color: Colors.blue,),
                        title: Text((list[i]["listcode"]==null?"未定义":list[i]["listcode"])+"             "+(list[i]["listingsubtitle"]==null ? "未填写":list[i]["listingsubtitle"]), style: TextStyle(fontSize: 15),),
                        subtitle:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Divider(height: 5.0,color: Colors.transparent,),
                            Text("单位："+(list[i]["unit"]==null ? "未填写":list[i]["unit"])+"             "+"工程量："+(list[i]["quantities"]==null ? "未填写":list[i]["quantities"].toString()),style: TextStyle(fontSize: 12),),
                            Divider(height: 5.0,color: Colors.transparent,),
                            Text("综合单价："+(list[i]["comprehensiveprice"]==null ? "未填写":list[i]["comprehensiveprice"].toString())+"             "+"合计："+(list[i]["combinedprice"]==null ? "未填写":list[i]["combinedprice"].toString()),style: TextStyle(fontSize: 12),),
                            Divider(height: 5.0,color: Colors.transparent,),
                          ],
                        ),
                      /*  onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                            return IncomeContracInfoPage(list[i]["id"]);
                          }));
                        },*/
                      ),
                    ),
                  ]),
            )
        );
      }
    return Container(
        height: 70,
        child: ListView(
            children:Items,
        )
    );
  }
  //获取立项项目数据详情
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("incomeContract/appFormLoad", data: {
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
        .post("quantitiesList/listLoadById", data: {
      "page": this.page,
      "rows": this.rows,
      "incomeContractId":widget.Id,
    });
    var result = json.decode(results.data);

    if (result["total"] > 0) {
      showToast("获取数据成功");
      setState(() {
        this.list = result["rows"] as List;
      });
    } else {
      showToast("请稍后尝试!");
    }
  }
}
