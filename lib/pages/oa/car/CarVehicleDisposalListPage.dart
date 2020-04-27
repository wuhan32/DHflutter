import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/oa/car/CarVehicleDisposalFormPage.dart';
import 'package:oa/pages/oa/car/CarVehicleDisposalInfoPage.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class CarVehicleDisposalListPage extends StatefulWidget {
  @override
  _CarVehicleDisposalListPageState createState() =>
      _CarVehicleDisposalListPageState();
}

class _CarVehicleDisposalListPageState
    extends State<CarVehicleDisposalListPage> {
  final page = 1;
  final rows = 20;
  List list = new List();

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('车辆处置'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return CarVehicleDisposalFormPage(false);
                })).then((_){
                  toList();
                });
              },
            )
          ],
        ),
        body: Container(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder:(context,i){
             return Card(
               color: Color(0xffffffff),
               margin: EdgeInsets.only(top: 1),
               child: Row(
                   children: <Widget>[
                     new Expanded(
                       child: ListTile(
                         leading: new Icon(Icons.build,color: Colors.blue,),
                         title: Text(list[i]["vehiclenumber"],style: TextStyle(fontSize: 14),),
                         subtitle: Text("处置性质:"+list[i]["sysname"],style: TextStyle(fontSize: 12),),
                         trailing:Text(list[i]["brandtype"],style: TextStyle(fontSize: 12),),
                         onTap: (){
                           Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                             return CarVehicleDisposalInfoPage(list[i]["id"]);
                           })).then((_){
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
  void deactivate() {
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      toList();
    }
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

  //获取车辆处置
  Future<Map> toList() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehicledisposal/listLoad", data: {
      "page": this.page,
      "rows": this.rows,
    });
    var result = json.decode(results.data);
    print(result);
      if (result["total"] > 0) {
        setState(() {
          this.list = result["rows"] as List;
        });
        print(this.list.length);
      } else {
        setState(() {
          this.list =[];
        });
      }

  }
}
