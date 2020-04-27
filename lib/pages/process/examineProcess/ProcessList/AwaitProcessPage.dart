//待签流程
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oa/utils/DateTimeUtil.dart';

class Await extends StatefulWidget {
  @override
  _Await createState() => _Await();
}

class _Await extends State<Await> {
  final page = 1;
  final rows = 10;
  List list = new List();
  int _suspensionHeight = 40;
  int _itemHeight = 65;
  String _suspensionTag = "";

  Widget build(BuildContext context) {
    return   ListView(
        children: buildNews(),
    );
  }


  //构建列表
  List<Widget> buildNews() {
    List<Widget> items = [];
    items.add(SizedBox(height: 5,));
    if(this.list.length>0) {
      for (int i = 0; i < this.list.length; i++) {
        items.add(
            Card(
              color: Color(0xffffffff),
              margin: EdgeInsets.only(top: 2),
              child: Row(
                  children: <Widget>[
                    new Expanded(
                      child: ListTile(
                        title: Text(list[i]["processDefinitionName"],style: TextStyle(fontSize: 14),),
                        subtitle: Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children: <Widget>[
                            Divider(height: 3.0,color: Colors.transparent,),
                            Text("申请人："+list[i]["startUser"],style: TextStyle(fontSize: 12),
                            ),
                            Divider(height: 3.0,color: Colors.transparent,),
                            Text("申请时间："+DateTimeUtil.formatDateString(list[i]["startTime"]),style: TextStyle(fontSize: 12),),
                          ],
                        ),

                        trailing:Text("请确认签收",style: TextStyle(fontSize: 12),),
                        onTap: (){
                          _showCupertinoAlertDialog(int.parse(list[i]["taskId"]));
                        },
                      ),
                    ),
                  ]),

            )
        );
      }
    }else{
      items.add( Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 240, bottom: 10, left: 15, right: 3),
        child: Text(
          '暂无流程',
          style: new TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            letterSpacing: 2.0,
          ),
        ),
      ),
      );
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    toList();
  }

  void _showCupertinoAlertDialog(int taskid) {
    var title = Row(//标题
      mainAxisAlignment: MainAxisAlignment.center,
    );
    var content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("请确认签收",style: TextStyle(fontSize: 18),),
        ],
    );
    var dialog = CupertinoAlertDialog(
      content: content,
      title: title,
      actions: <Widget>[
        CupertinoButton( child: Text("确认"),
          onPressed: () {
            gitsign(taskid).then((res) {
              if(res["status"]) {
                showToast("签收成功");
                Navigator.pop(context);
                toList();
              }else {
                showToast("签收失败");
              }
            });
          }),
        CupertinoButton( child: Text("取消"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }

//待签列表
  Future<Map> toList() async {
    Response results = await HttpUtil.getInstance(context)
        .post("appProcess/loadNeedClaimTask", data: {
      "page": this.page,
      "rows": this.rows,
    });
    Map result = json.decode(results.data);
    if (result["total"] > 0) {
      setState(() {
        this.list = result["rows"] ;
      });
    } else {
      showToast("请稍后尝试!");
    }
  }
  //确认签收
  Future<Map> gitsign(int taskid) async {
    Response results = await HttpUtil.getInstance(context)
        .post("appProcess/claimTask", data: {
      "taskId":taskid,
    });
    print(taskid);
    Map result = json.decode(results.data);
    //print(result);
    return result;
  }


}






