import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oa/pages/project/Completion/CompletionInfoPage.dart';
class CompletionList extends StatefulWidget{
  @override
  _PjCompletionListState  createState()=>_PjCompletionListState();
}
class _PjCompletionListState extends State<CompletionList> {
  final page = 1;//当前页
  final rows = 20;//显示条数
  List list = new List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('完工结算查询'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, "CompletionInfoPage");
              },
            )
          ],
        ),
        body: Container(
          child: ListView(
            children: buildNews(),
          ),
        )
    );
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
                      leading: new Icon(Icons.money_off,color: Colors.blue,),
                      title: Text((list[i]["completionno"] == null ? "未填写":list[i]["completionno"]), style: TextStyle(fontSize: 14),),
                      subtitle:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Divider(height: 5.0,color: Colors.transparent,),
                          Text("结算名称："+(list[i]["completionname"]== null ? "未填写":list[i]["completionname"]),style: TextStyle(fontSize: 12),),
                          Divider(height: 5.0,color: Colors.transparent,),
                          Text("合同名称："+(list[i]["contractname"] ==null ? "未填写":list[i]["contractname"]),style: TextStyle(fontSize: 12),),
                          Divider(height: 5.0,color: Colors.transparent,),
                          Text("所属项目："+(list[i]["projectname"] ==null ? "未填写":list[i]["projectname"]),style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      //trailing:Text(list[i]["statusName"],style: TextStyle(fontSize: 12),),//状态
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return CompletionInfoPage(list[i]["id"]);
                        }));
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    toList();
  }
  //获取项目列表记录
  Future<Map> toList() async {
    Response results = await HttpUtil.getInstance(context)
        .post("completion/appListLoad", data: {
      "page": this.page,
      "rows": this.rows,
    });
    var result = json.decode(results.data);

    if (result["total"] > 0) {
      showToast("获取数据成功");
      setState(() {
        this.list = result["rows"] as List;
      });
    } else {
      showToast("请稍后尝试!");
    }

  }
}