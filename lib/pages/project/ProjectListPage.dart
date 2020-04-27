import 'package:flutter/material.dart';
import 'package:oa/modle/FuncItem.dart';
import 'package:oktoast/oktoast.dart';

class ProjectListPage extends StatefulWidget {
  @override
  _OaListPageState createState() => _OaListPageState();
}

class _OaListPageState extends State<ProjectListPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: new AppBar(
          centerTitle: true ,
          title: new Text("项目管理"),
        /*  title: Center(
            child: Text(
              '项目管理',
              style: new TextStyle(fontSize: 16.0),
            ),
          ),*/
        ),
        body: ListView(
          children: <Widget>[
            Divider(height: 10, color: Colors.transparent),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 0, bottom: 10, left: 15, right: 3),
              child: Text(
                '项目管理',
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            buildFuncArea(),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 0, bottom: 10, left: 15, right: 3),
              child: Text(
                  '收入合同',
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    letterSpacing: 2.0,
                  ),
              ),
            ),
            buildFuncArea4(),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 0, bottom: 10, left: 15, right: 3),
              child: Text(
                '收入报表',
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            buildFuncArea1(),
          ],
        ));
  }

  List funcItems = [
    FuncItem(
        title: "项目申报",
        icon: Icon(Icons.add, size: 15,color: Colors.blue),
        route: ""),
    FuncItem(
        title: "项目列表",
        icon: Icon(Icons.assignment, size: 15,color: Colors.blue),
        route: "ProjectDeclaration"),
  ];

  List Items1 = [
    FuncItem(title: "收入合同", icon: Icon(Icons.assignment, size: 15,color: Colors.green), route: ''),
    FuncItem(title: "收入合同明细", icon: Icon(Icons.assignment, size: 15,color: Colors.green), route: null),
    FuncItem(title: "收入合同报表", icon: Icon(Icons.assignment, size: 15,color: Colors.green), route: null),
    FuncItem(title: "合同收款", icon: Icon(Icons.attach_money, size: 15,color: Colors.green), route: null),
    FuncItem(title: "合同付款", icon: Icon(Icons.monetization_on, size: 15,color: Colors.green), route: null),
  ];
  //行政事务
  List Items4 = [
    FuncItem(title: "收入合同", icon: Icon(Icons.assignment, size: 15,color: Colors.deepOrange), route: 'IncomeContractList'),
    FuncItem(title: "合同收款", icon: Icon(Icons.attach_money, size: 15,color: Colors.deepOrange), route: 'ProceedsContractList'),
    FuncItem(title: "合同付款", icon: Icon(Icons.monetization_on, size: 15,color: Colors.deepOrange), route: 'PaymentContractList'),
    FuncItem(title: "进度款结算", icon: Icon(Icons.money_off, size: 15,color: Colors.deepOrange), route: 'ScheduleProjectList'),
    FuncItem(title: "完工结算", icon: Icon(Icons.computer, size: 15,color: Colors.deepOrange), route: 'CompletionList'),
  ];

  //构建功能区-项目管理
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
                Text(funcItems[i - 1].title, style: TextStyle(fontSize: 10,fontWeight: FontWeight.w100),)
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


//构建功能区--收入报表
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
                Text(Items1[i - 1].title, style: TextStyle(fontSize: 10,fontWeight: FontWeight.w100))
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
//构建功能区--收入合同
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
                Text(Items4[i - 1].title, style: TextStyle(fontSize: 10,fontWeight: FontWeight.w100))
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
}
