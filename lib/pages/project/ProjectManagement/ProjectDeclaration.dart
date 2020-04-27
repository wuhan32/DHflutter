import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oa/pages/project/ProjectManagement/ProjectDeclarationInfoPage.dart';
import 'package:oa/utils/HttpUtil.dart';

class ProjectDeclaration extends StatefulWidget{
  @override
  _PjProjectDeclarationState  createState()=>_PjProjectDeclarationState();
}
class _PjProjectDeclarationState extends State<ProjectDeclaration> {
    final page = 1;//当前页
    final rows = 20;//显示条数
    List list = new List();
   @override
   Widget build(BuildContext context) {
     return Scaffold(
         appBar: new AppBar(
           title: Center(
             child: Text('项目列表'),
           ),
           actions: <Widget>[
             IconButton(
               icon: Icon(Icons.search),
               onPressed: () {
                 Navigator.pushNamed(context, "IncomeContracInfoMain");
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
                        leading: new Icon(Icons.assignment,color: Colors.blue,),
                        title: Text(list[i]["project_name"], style: TextStyle(fontSize: 14),),
                        subtitle:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Divider(height: 5.0,color: Colors.transparent,),
                            Text("项目名称："+(list[i]["project_name"]==null ? "未填写":list[i]["project_name"]),style: TextStyle(fontSize: 12),),
                            Divider(height: 5.0,color: Colors.transparent,),
                            Text("项目地址："+(list[i]["project_area"]==null ? "未填写":list[i]["project_area"]),style: TextStyle(fontSize: 12),),
                            Divider(height: 5.0,color: Colors.transparent,),
                          ],
                        ),
                        trailing:Text(list[i]["construction_unit"],style: TextStyle(fontSize: 12),),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                            return ProjectDeclarationInfoPage(list[i]["id"]);
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
          .post("contractProject/listLoad", data: {
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
        print(list[0]["project_name"]);
      } else {
        showToast("请稍后尝试!");
      }

    }
}