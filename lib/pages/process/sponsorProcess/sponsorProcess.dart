//首页
import 'package:flutter/material.dart';
import 'package:oa/pages/process/sponsorProcess/initiate/VehicleInitiate.dart';


class sponsorProcess extends StatefulWidget {
  @override
  _sponsorProcess createState() => _sponsorProcess();
}

class _sponsorProcess extends State<sponsorProcess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("申请流程列表")), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.cached),
          tooltip: "刷新",
          onPressed: () {
            initState();
          },
        )
      ]),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("车辆相关流程申请",
                  style: TextStyle(fontSize: 12),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left:15,top: 14),
                      child:GestureDetector(
                        onTap:() {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                            return VehicleInitiate();
                          }));
                        },
                        child:Column(
                          children: <Widget>[
                            Icon(
                              Icons.directions_car,
                              color: Colors.redAccent,
                            ),
                            Text(
                              "车辆申请",
                              style: TextStyle( color: Colors.redAccent),
                            ),
                          ],
                        )
                      ),

                    ),
                    Container(
                      margin: EdgeInsets.only(left:20,top: 14),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.directions_car,
                            color: Colors.redAccent,
                          ),
                          Text(
                            "车辆申请",
                            style: TextStyle( color: Colors.redAccent),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left:20,top: 14),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.directions_car,
                            color: Colors.redAccent,
                          ),
                          Text(
                            "车辆申请",
                            style: TextStyle( color: Colors.redAccent),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left:20,top: 14),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.directions_car,
                            color: Colors.redAccent,
                          ),
                          Text(
                            "车辆申请",
                            style: TextStyle( color: Colors.redAccent),
                          ),

                        ],
                      ),
                    ),


                  ],
                )
              ],
            ),
          ),

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
