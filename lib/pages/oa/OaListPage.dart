import 'package:flutter/material.dart';
import 'package:oa/modle/FuncItem.dart';
import 'package:oktoast/oktoast.dart';

class OaListPage extends StatefulWidget {
  @override
  _OaListPageState createState() => _OaListPageState();
}

class _OaListPageState extends State<OaListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text(
              '行政办公',
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Divider(height: 10, color: Colors.transparent),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 0, bottom: 10, left: 12, right: 3),
              child: Text(
                '行政事务',
                style: new TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            buildFuncArea4(),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 0, bottom: 10, left: 12, right: 3),
              child: Text(
                '车辆管理',
                style: new TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            buildFuncArea(),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 0, bottom: 10, left: 12, right: 3),
              child: Text(
                '信息管理',
                style: new TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            buildFuncArea1(),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 0, bottom: 10, left: 12, right: 3),
              child: Text(
                '资料管理',
                style: new TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            buildFuncArea2(),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 0, bottom: 10, left: 12, right: 3),
              child: Text(
                '考勤管理',
                style: new TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            buildFuncArea3(),
          ],
        ));
  }

  List funcItems = [
    FuncItem(
        title: "车辆分派",
        icon: Icon(Icons.directions_car, size: 15, color: Colors.blue),
        route: "CarVehicleAssignrecordListPage"),
    FuncItem(
        title: "行驶记录",
        icon: Icon(Icons.crop, size: 15, color: Colors.blue),
        route: "CarVehicleDrivereCordListPage"),
    FuncItem(
        title: "车辆预警",
        icon: Icon(Icons.timer, size: 15, color: Colors.blue),
        route: "CarVehiclereMinderListPage"),
    FuncItem(
        title: "车辆处置",
        icon: Icon(Icons.build, size: 15, color: Colors.blue),
        route: "CarVehicleDisposalListPage"),
    FuncItem(
        title: "车辆费用",
        icon: Icon(Icons.monetization_on, size: 15, color: Colors.blue),
        route: "CarVehicleFeeListPage"),
  ];

  List Items1 = [
    FuncItem(
        title: "信息发布",
        icon: Icon(Icons.message, size: 15, color: Colors.green),
        route: null),
  ];

  List Items2 = [
    FuncItem(
        title: "资料查询",
        icon: Icon(Icons.search, size: 15, color: Colors.amberAccent),
        route: null),
    FuncItem(
        title: "目录管理",
        icon: Icon(Icons.receipt, size: 15, color: Colors.amberAccent),
        route: null),
  ];

  List Items3 = [
    FuncItem(
        title: "考勤查询",
        icon: Icon(Icons.search, size: 15, color: Colors.greenAccent),
        route: "SignRecordPage"),
    FuncItem(
        title: "历史记录",
        icon: Icon(Icons.menu, size: 15, color: Colors.greenAccent),
        route: null),
  ];

  //行政事务
  List Items4 = [
    FuncItem(
        title: "领导日程",
        icon: Icon(Icons.event_note, size: 15, color: Colors.deepOrange),
        route: "DailyRecordPage"),
    FuncItem(
        title: "办公用品申购",
        icon:
            Icon(Icons.local_grocery_store, size: 15, color: Colors.deepOrange),
        route: "PurchaseApplyListPage"),
    FuncItem(
        title: "办公用品申领",
        icon: Icon(Icons.open_in_browser, size: 15, color: Colors.deepOrange),
        route: "SuppliesApplyListPage"),
    FuncItem(
        title: "培训安排",
        icon: Icon(Icons.apps, size: 15, color: Colors.deepOrange),
        route: "TrainingPlanListPage"),
    FuncItem(
        title: "会议申请",
        icon: Icon(Icons.drafts, size: 15, color: Colors.deepOrange),
        route: null),
  ];

  //构建功能区
  Widget buildFuncArea() {
    List<Widget> items = List();
    for (int i = 1; i <= funcItems.length; i++) {
      items.add(GestureDetector(
        onTap: () {
          if (funcItems[i - 1].route == null) {
            showNotDevelop();
          } else {
            Navigator.pushNamed(context, funcItems[i - 1].route);
          }
        },
        child: Container(
            color: Color(0x2196F3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                funcItems[i - 1].icon,
                Text(
                  funcItems[i - 1].title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
                )
              ],
            )),
      ));
    }
    return Container(
      height: 70,
      child: GridView.count(
          crossAxisCount: 5, childAspectRatio: 2, children: items),
    );
  }

//构建功能区--信息管理
  Widget buildFuncArea1() {
    List<Widget> items = List();
    for (int i = 1; i <= Items1.length; i++) {
      items.add(GestureDetector(
        onTap: () {
          if (Items1[i - 1].route == null) {
            showToast("暂未开发");
          } else {
            Navigator.pushNamed(context, Items1[i - 1].route);
          }
        },
        child: Container(
            color: Color(0xffffff),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Items1[i - 1].icon,
                Text(Items1[i - 1].title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100))
              ],
            )),
      ));
    }
    return Container(
      height: 70,
      child: GridView.count(
          crossAxisCount: 5, childAspectRatio: 2, children: items),
    );
  }

//构建功能区--资料管理
  Widget buildFuncArea2() {
    List<Widget> items = List();
    for (int i = 1; i <= Items2.length; i++) {
      items.add(GestureDetector(
        onTap: () {
          if (Items2[i - 1].route == null) {
            showToast("暂未开发");
          } else {
            Navigator.pushNamed(context, Items2[i - 1].route);
          }
        },
        child: Container(
            color: Color(0xffffff),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Items2[i - 1].icon,
                Text(Items2[i - 1].title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100))
              ],
            )),
      ));
    }
    return Container(
      height: 70,
      child: GridView.count(
          crossAxisCount: 5, childAspectRatio: 2, children: items),
    );
  }

//构建功能区--考勤管理
  Widget buildFuncArea3() {
    List<Widget> items = List();
    for (int i = 1; i <= Items3.length; i++) {
      items.add(GestureDetector(
        onTap: () {
          if (Items3[i - 1].route == null) {
            showToast("暂未开发");
          } else {
            Navigator.pushNamed(context, Items3[i - 1].route);
          }
        },
        child: Container(
            color: Color(0xffffff),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Items3[i - 1].icon,
                Text(Items3[i - 1].title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100))
              ],
            )),
      ));
    }
    return Container(
      height: 70,
      child: GridView.count(
          crossAxisCount: 5, childAspectRatio: 2, children: items),
    );
  }

//构建功能区--行政事务
  Widget buildFuncArea4() {
    List<Widget> items = List();
    for (int i = 1; i <= Items4.length; i++) {
      items.add(GestureDetector(
        onTap: () {
          if (Items4[i - 1].route == null) {
            showToast("暂未开发");
          } else {
            Navigator.pushNamed(context, Items4[i - 1].route);
          }
        },
        child: Container(
            color: Color(0xffffff),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Items4[i - 1].icon,
                Text(Items4[i - 1].title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100))
              ],
            )),
      ));
    }
    return Container(
      height: 70,
      child: GridView.count(
          crossAxisCount: 5, childAspectRatio: 2, children: items),
    );
  }

  //显示未开发功能提示
  void showNotDevelop() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Container(
        height: 20,
        alignment: Alignment.center,
        child: Text("暂未开发"),
      ),
      duration: Duration(milliseconds: 200),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  void show() {
//总条数
    int sum = 70;
//余
    int y = 0;
//第一个结果集
    int A = 67;
//第二个结果集
    int B = 3;
//第三个结果集
    int C = 0;
//当前页数
    int page = 1;
//每页显示条数
    int size = 20;
    int num=0;
    if ((page - 1) * size < A) {
      var a=[20,20,20,7];
      int countA = a[page-1]; //limit page,size   //获取当前页数的总数
      y = size - countA; //获取差值
      if (y < size) {
        //判断差值是否小于size（20）
        //如果小于，则从第二个结果集中获取
        int countB = B-y; // B limit y affcet 0  ;
        if (countB < size) {
          //判断从第二个结果集中获取的数是否小于size（20）
          //如果小于，则从第三个结果集中获取
          int countC = C-20+countB; //C limit size-countB affcet 0  ;
          y = size - countC; //记录获取到第三个个结果集开始的位置;
          //这里终止：   结果集为：countA+countB+countC
        } else {
          y = countB; //记录获取到第二个结果集开始的位置；
          //这里终止：   结果集为：countA+countB
        }
      } //这里终止了  结果集为：countA

    } else if ((page - 1) * size - A < B) {
      if (y > 0) {

        int countB = 20; //B limit 20 affcet y;
        if (countB < size) {
          //判断从第二个结果集中获取的数是否小于size（20）
          //如果小于，则从第三个结果集中获取
          int countC = 20; //C limit size-countB affcet 0  ;
          y = size - countC; //记录获取到第三个个结果集开始的位置;
          //这里终止：   结果集为：countB+countC
        } else {
          y = countB + y; //记录获取到第二个结果集开始的位置;
          //这里终止：   结果集为：countB
        }
      } else {
        int countB = 20; //B limit 20 affcet 0;
        y = countB; //记录获取到第二个结果集开始的位置;
      }
    } else if ((page - 1) * size - A - B < C) {
      if (y > 0) {
        int countC = 20; //C limit 20 affcet y;
        if (countC == size) {
          y = y + countC;
        }
      } else {
        int countC = 20; //C limit 20 affcet 0;
        y = countC; //记录获取到第二个结果集开始的位置;
      }
    }
  }
}
