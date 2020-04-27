import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleDrivereCordInfoPage.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class CarVehicleDrivereCordListPage extends StatefulWidget {
  @override
  _CarVehicleDrivereCordListPageState createState() =>
      _CarVehicleDrivereCordListPageState();
}

class _CarVehicleDrivereCordListPageState
    extends State<CarVehicleDrivereCordListPage> {
  final page = 1;
  final rows = 20;
  List list = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('行驶记录'),
          ),
        ),
        body: Container(
          child: ListView(
            children: buildNews(),
          ),
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
          new Expanded(
            child: ListTile(
              leading: new Icon(
                Icons.crop,
                color: Colors.blue,
              ),
              title: Text(
                "行驶里程：" + list[i]["mileage"] + "Km",
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                "总费用：" + list[i]["usefee"] + "元",
                style: TextStyle(fontSize: 12),
              ),
              trailing: Text(
                "油价（元/升）：" + list[i]["oilprice"],
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return CarVehicleDrivereCordInfoPage(
                      list[i]["id"].toString());
                }));
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
    Response results = await HttpUtil.getInstance(context)
        .post("vehicledriverecord/listLoad", data: {
      "page": this.page,
      "rows": this.rows,
    });
    var result = json.decode(results.data);
    print(result);
    if (result["total"] > 0) {
      showToast("获取数据成功");
      setState(() {
        this.list = result["rows"] as List;
      });
      print(this.list[0]["id"].toString());
    } else {
      showToast("请稍后尝试!");
    }
  }
}
