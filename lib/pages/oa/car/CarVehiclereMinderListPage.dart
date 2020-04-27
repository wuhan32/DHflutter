import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleFeeInfoPage.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class CarVehiclereMinderListPage extends StatefulWidget {
  @override
  _CarVehiclereMinderListPageState createState() =>
      _CarVehiclereMinderListPageState();
}

class _CarVehiclereMinderListPageState
    extends State<CarVehiclereMinderListPage> {
  final page = 1;
  final rows = 20;
  List list = new List();

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('车辆预警'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                toList();
              },
            )
          ],
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
      Items.add(
          Card(
            color: Color(0xffffffff),
            margin: EdgeInsets.only(top: 1),
            child: Row(
                children: <Widget>[
                  new Expanded(
                    child: ListTile(
                      leading: new Icon(Icons.timer,color: Colors.blue,),
                      title: Text("预警类型："+list[i]["name"],style: TextStyle(fontSize: 14),),
                      subtitle:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Divider(height: 5.0,color: Colors.transparent,),
                          Text("提醒用户："+list[i]["reminderpersonname"],style: TextStyle(fontSize: 12),),
                          Divider(height: 5.0,color: Colors.transparent,),
                          Text(list[i]["beforemonth"],style: TextStyle(fontSize: 12),),Divider(height: 5.0,color: Colors.transparent,),
                        ],
                      ),
                      onTap: (){
                      },
                    ),
                  ),
                ]),

          )
      );
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
        .post("vehiclereminder/listLoad", data: {
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
      } else {
        showToast("请稍后尝试!");
      }

  }
}
