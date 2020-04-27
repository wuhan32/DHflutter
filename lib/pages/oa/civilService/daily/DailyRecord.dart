import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mini_calendar/mini_calendar.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';

import 'DailyEditPage.dart';
import 'DailyFormPage.dart';



//领导日程记录
class DailyRecordPage extends StatefulWidget {

  @override
  DailyRecordState createState() => new DailyRecordState();

}


class DailyRecordState extends State<DailyRecordPage> {

  MonthPageController controller;
  DateMonth month = DateMonth.now();
  DateDay day = DateDay.now();
  String data = '';
  List<Widget> dailyRecord=[];
  List list = new List();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('领导日程'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return  DailyFormPage(this.day);
              })).then((_){
                loadDailyRecord(this.day);//重新获取数据
              });
            },
          )
        ],
      ),
      body: Column(
          children: <Widget>[
            Expanded(
              flex: 12,
              child: MonthPageView(
                weekHeadColor: Colors.lightBlueAccent,
                padding: EdgeInsets.all(1),
                scrollDirection: Axis.horizontal,
                option: MonthOption(
                  currentDay: DateDay.now(),
                  marks: {},
                ),
                showWeekHead: true,
                onDaySelected: (day, data) {
                  this.day = day;
                  this.data = data;
                  setState(() {
                    loadDailyRecord(this.day);
                  });
                },
                onCreated: (controller){
                  this.controller = controller;
                },
                localeType: LocaleType.zh,
              )
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: ListView(
                  children:dailyRecord,
                ),
              ),
            )
          ],
        ),
    );
  }


  //根据选择的时间加载领导日程数据
  void loadDailyRecord(DateDay day){
    HttpUtil.getInstance(context).get(
      "daily/appFormLoad",
      data: {"date":day.toString()}).then((response){
        Map reslut=json.decode(response.data);
        setState(() {
          this.dailyRecord=[];
          this.list = reslut["rows"] as List;
          if( reslut["total"]>0){
            for(int i=0;i<list.length;i++){
              Map record=reslut["rows"][i];
              this.dailyRecord.add(
                  Card(
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(Icons.calendar_today,color: Colors.blue,),
                      title: Text(record["title"]),
                      //subtitle: Text(record["remark"]==null?"":(record["remark"].toString().length>5?record["remark"].toString().substring(0,5):record["remark"]))
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context){
                            return DailyEditPage(record["id"]);
                          })
                        ).then((_){
                          loadDailyRecord(this.day);
                        });
                      },
                    ),
                  )
              );
            }
          }else{
            this.dailyRecord.add(
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: Text("无记录",style: TextStyle(fontSize: 18),),
                ),
              )
            );
          }
        });
      });
  }


  @override
  void initState() {
    loadDailyRecord(DateDay.now());
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}