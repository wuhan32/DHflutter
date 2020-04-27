import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleAssignrecordFromPage.dart';
import 'package:oa/pages/oa/car/CarVehicleAssignrecordInfoPage.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class CarVehicleAssignrecordListPage extends StatefulWidget {
  @override
  _CarVehicleAssignrecordListPageState createState() =>
      _CarVehicleAssignrecordListPageState();
}

class _CarVehicleAssignrecordListPageState
    extends State<CarVehicleAssignrecordListPage> {
  final page = 1;
  final rows = 20;
  List list = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('车辆分派'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return CarVehicleAssignrecordFromPage(false);
                })).then((_) {
                  toList();
                });
              },
            )
          ],
        ),
        body: Container(
          child: ListView(
            children: buildList(),
          ),
        ));
  }

  //构建列表
  List<Widget> buildList() {
    List<Widget> Items = [];
    Items.add(Container(
      margin: EdgeInsets.only(bottom: 4),
    ));
    for (int i = 0; i < this.list.length; i++) {
      Items.add(Card(
        color: Color(0xffffffff),
        margin: EdgeInsets.only(top: 1),
        child: Row(children: <Widget>[
          new Expanded(
            child: ListTile(
              leading: new Icon(
                Icons.directions_car,
                color: Colors.blue,
              ),
              title: Text(
                list[i]["vehiclenumber"],
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
                    "驾驶人员：" + list[i]["drivername"],
                    style: TextStyle(fontSize: 12),
                  ),
                  Divider(
                    height: 5.0,
                    color: Colors.transparent,
                  ),
                  Text(
                    "派车时间：" + list[i]["assignstarttime"],
                    style: TextStyle(fontSize: 12),
                  ),
                  Divider(
                    height: 5.0,
                    color: Colors.transparent,
                  ),
                ],
              ),
              trailing: Text(
                list[i]["statusname"],
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return CarVehicleAssignrecordInfoPage(list[i]["id"]);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    toList();
  }

  //获取车辆分派记录
  Future<Map> toList() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehicleassignrecord/listLoad", data: {
      "page": this.page,
      "rows": this.rows,
    });
    var result = json.decode(results.data);
      if (result["total"] > 0) {
        showToast("获取数据成功");
        setState(() {
          this.list = result["rows"] as List;
        });
        print(this.list.length);
        print(list[0]["vehiclenumber"]);
      } else {
        showToast("请稍后尝试!");
      }
  }
}
