import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleFeeFormPage.dart';
import 'package:oa/pages/oa/car/CarVehicleFeeInfoPage.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

import 'SuppliesApplyInfoPage.dart';

class SuppliesApplyListPage extends StatefulWidget {
  @override
  _SuppliesApplyListPageState createState() => _SuppliesApplyListPageState();
}

class _SuppliesApplyListPageState extends State<SuppliesApplyListPage> {
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
                        Icons.open_in_browser,
                        color: Colors.blue,
                      ),
                      title: Text(
                        "用品名称：" +
                          (list[index]["pname"]==null?"":list[index]["pname"]),
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
                            "申请日期：" + (list[index]["applydate"]==null?"":DateTimeUtil.formatDateString(list[index]["applydate"] as int)),
                            style: TextStyle(fontSize: 12),
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                      trailing: Text(
                          (list[index]["dsysext1"]==null?"":list[index]["dsysext1"]),
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return SuppliesApplyInfoPage(list[index]["id"]);
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
    await HttpUtil.getInstance(context).post("suppliesapply/listLoad", data: {
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
