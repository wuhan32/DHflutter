import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleFeeFormPage.dart';
import 'package:oa/pages/oa/car/CarVehicleFeeInfoPage.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class CarVehicleFeeListPage extends StatefulWidget {
  @override
  _CarVehicleFeeListPageState createState() => _CarVehicleFeeListPageState();
}

class _CarVehicleFeeListPageState extends State<CarVehicleFeeListPage> {
  final page = 1;
  final rows = 20;
  List list = new List();

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('车辆费用'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return CarVehicleFeeFormPage(false);
                })).then((_) {
                  toList();
                });
              },
            )
          ],
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
                        Icons.build,
                        color: Colors.blue,
                      ),
                      title: Text(
                        "用户：" + list[index]["feerecpersonname"] == null
                            ? ""
                            : list[index]["feerecpersonname"],
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        list[index]["feedate"] == null ? "" : list[index]["feedate"],
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        "金额：" + list[index]["feevalue"] == null
                            ? ""
                            : list[index]["feevalue"] + "元",
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return CarVehicleFeeInfoPage(list[index]["id"]);
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
//          ListView(
//            children: buildNews(),
//          ),
        ));
  }

  //构建列表
  List<Widget> buildNews() {
    List<Widget> Items = [];
    Items.add(Container(
      margin: EdgeInsets.only(bottom: 4),
    ));
    for (int i = 0; i < this.list.length; i++) {
      Items.add(Card(
        color: Color(0xffffffff),
        margin: EdgeInsets.only(top: 1),
        child: Row(children: <Widget>[
          new Container(
            child: ListTile(
              leading: new Icon(
                Icons.monetization_on,
                color: Colors.blue,
              ),
              title: Text(
                "用户：" + list[i]["feerecpersonname"],
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                list[i]["feedate"],
                style: TextStyle(fontSize: 12),
              ),
              trailing: Text(
                "金额：" + list[i]["feevalue"] + "元",
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return CarVehicleFeeInfoPage(list[i]["id"]);
                })).then((_) {
                  toList();
                });
              },
            ),
          ),
        ]),
      ));
    }
    return Items;
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

  //获取车辆分派记录
  Future<Map> toList() async {
    Response results =
        await HttpUtil.getInstance(context).post("vehiclefee/listLoad", data: {
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
