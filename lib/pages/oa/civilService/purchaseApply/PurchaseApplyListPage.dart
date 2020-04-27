import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleFeeFormPage.dart';
import 'package:oa/pages/oa/car/CarVehicleFeeInfoPage.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

import 'PurchaseApplyInfoPage.dart';

class PurchaseApplyListPage extends StatefulWidget {
  @override
  _PurchaseApplyListPageState createState() => _PurchaseApplyListPageState();
}

class _PurchaseApplyListPageState extends State<PurchaseApplyListPage> {
  final page = 1;
  final rows = 20;
  List list = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('办公用品申购'),
          ),
        ),
        body: Container(
          child:
          ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Card(
                color: Color(0xffffffff),
                margin: EdgeInsets.only(top: 1),
                child: Row(children: <Widget>[
                  new Expanded(
                    child: ListTile(
                      leading: new Icon(
                        Icons.local_grocery_store,
                        color: Colors.blue,
                      ),
                      title: Text(
                        "用品名称：" +
                          (list[index]["cname"]==null?"":list[index]["cname"]),
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Divider(
                            height: 5.0,
                            color: Colors.transparent,
                          ),
                          Text(
                            "申请人：" + (list[index]["proposer"]==null?"":list[index]["proposer"]),
                            style: TextStyle(fontSize: 12),
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.transparent,
                          ),
                          Text(
                            "申请日期：" + (list[index]["applydate"]==null?"":list[index]["applydate"]),
                            style: TextStyle(fontSize: 12),
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                      trailing: Text(
                          (list[index]["dspurchaseapplystatus"]==null?"":list[index]["dspurchaseapplystatus"]),
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return PurchaseApplyInfoPage(list[index]["id"],list[index]["purchaseapplystatus"]=="cp1561536136652"?true:false);
                            })).then((_) {
                          toList();
                        });
                      },
                    ),
                  ),
                ]),
              );
            },
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  //获取办公用品申购列表数据
  Future<Map> toList() async {
    Response results =
    await HttpUtil.getInstance(context).post("purchaseapply/listLoad", data: {
      "page": this.page,
      "rows": this.rows,
    });
    var result = json.decode(results.data);
    if (result["total"] > 0) {
      setState(() {
        this.list = result["rows"] as List;
      });
      print(this.list.length);
    } else {
      showToast("暂无数据!");
    }
  }
}
