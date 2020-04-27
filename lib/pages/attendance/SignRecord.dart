import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mini_calendar/mini_calendar.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';



//打卡记录
class SignRecordPage extends StatefulWidget {

  @override
  SignRecordState createState() => new SignRecordState();

}


class SignRecordState extends State<SignRecordPage> {

  MonthPageController controller;
  DateMonth month = DateMonth.now();
  DateDay firstDay, secondDay,day;
  String data = '';
  List<Widget> signRecord=[];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('打卡记录'),
        centerTitle: true,
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
                    loadSignRecord(this.day);
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
                  children:signRecord,
                ),
              ),
            )
          ],
        ),
    );
  }


  //根据选择的时间加载打卡数据
  void loadSignRecord(DateDay day){
    HttpUtil.getInstance(context).get(
      "attendancerecord/queryTheDate",
      data: {"date":day.toString()}).then((response){
        Map reslut=json.decode(response.data);
        setState(() {
          this.signRecord=[];
          if( reslut["total"]>0){
            Map record=reslut["rows"][0];
            for(int i=1;i<=2;i++){
              this.signRecord.add(
                  Card(
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(Icons.my_location,color: record["recordtime$i"]==null?Colors.grey:Colors.orange,),
                      title: Text("打卡班次$i"),
                      subtitle: Text(record["recordtime$i"]==null?"未打卡":"打卡时间:"+DateTimeUtil.formatDateTimeString(record["recordtime$i"])),
                      trailing: record["recordtime$i"]==null?Icon(Icons.beenhere,color: Colors.grey,):Icon(Icons.beenhere,color: Colors.orange,),
                    ),
                  )
              );
            }
          }else{
            this.signRecord.add(
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.receipt,size: 50,color: Colors.grey,),
                      Text("无记录",style: TextStyle(fontSize: 18,color: Colors.grey),)
                    ],
                  ),
                ),
              )
            );
          }
        });
      });
  }


  @override
  void initState() {
    loadSignRecord(DateDay.now());
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}