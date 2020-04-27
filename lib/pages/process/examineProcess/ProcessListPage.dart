import 'package:flutter/material.dart';
import 'package:oa/pages/process/examineProcess/Processlist/AwaitProcessPage.dart';
import 'package:oa/pages/process/examineProcess/Processlist/BacklogProcessPage.dart';
import 'package:oa/pages/process/examineProcess/Processlist/MyProcessPage.dart';
import 'package:oa/pages/process/examineProcess/Processlist/SucceeProcessPage.dart';
import 'package:oa/pages/process/sponsorProcess/initiate/VehicleInitiate.dart';

class ProcessList extends StatefulWidget {
  @override
  _ProcessList createState() => new _ProcessList();
}

class _ProcessList extends State<ProcessList> {
  int _currentIndex = 0;

  var _bottomList = [new MyProcess(), new Await(), new Backlog(), new Succee()];

  final _bottomNavigationColor = Colors.blue;

//导航
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: Center(child: Text('事务申请')),
          actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          tooltip: "添加",
          onPressed: () {
//            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
//             return sponsorProcess();
//            }));
            showModalBottomSheet<void>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                builder: (BuildContext context) {
                  return Container(
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      padding: const EdgeInsets.all(4.0),
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
                                    style: TextStyle( color: Colors.redAccent,fontSize: 11),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
        )
      ]),
      body: Container(
        child: _bottomList.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_note,
              color: _bottomNavigationColor,
            ),
            title: Text(
              '我的流程',
              style: TextStyle(color: _bottomNavigationColor),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.border_color,
                color: _bottomNavigationColor,
              ),
              title: Text(
                '待签流程',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.comment,
                color: _bottomNavigationColor,
              ),
              title: Text(
                '待办流程',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.event_available,
                color: _bottomNavigationColor,
              ),
              title: Text(
                '已办流程',
                style: TextStyle(color: _bottomNavigationColor),
              )),
        ],
        currentIndex: _currentIndex,
        onTap: (int i) {
          setState(() {
            _currentIndex = i;
          });
        },
      ),
    );
  }


  popupBuild() {
    return Container(
        height: 500.0,
        color: Colors.blue,

    );
  }

}
