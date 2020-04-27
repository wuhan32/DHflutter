import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class CarVehicleAssignrecordFromPage extends StatefulWidget {
  final bool saveOrupdate;
  final String Id;
  CarVehicleAssignrecordFromPage(this.saveOrupdate,{this.Id}) : super();
  @override
  _CarVehicleAssignrecordFromPageState createState() =>
      _CarVehicleAssignrecordFromPageState();
}

class _CarVehicleAssignrecordFromPageState
    extends State<CarVehicleAssignrecordFromPage> {
  //表单参数
  String assignrecordNo = "";
  String applyrecordid = "";
  String useVehPersonName = ""; //用车人
  String useVehPersonMobile = ""; //用车人手机
  String usevehreason = ""; //用车事由
  String rectime = ""; //登记时间
  String vehicleinfoid = ""; //分派车辆
  String vehicleinfoidStr = "";
  String driverName = ""; //指定驾驶人
  String temporaryDriver = ""; //临时驾驶人
  String temporaryDriverStr = ""; //显示驾驶人名称
  String assignstarttime = ""; //派车开始时间
  String fixendtime = ""; //规定归还时间

  var _assignrecordNo = new TextEditingController();
  var _applyrecordid = new TextEditingController();
  var _useVehPersonName = new TextEditingController(); //用车人
  var _useVehPersonMobile = new TextEditingController(); //用车人手机
  var _usevehreason = new TextEditingController(); //用车事由
  var _rectime = new TextEditingController(); //登记时间
  var _vehicleinfoid = new TextEditingController(); //分派车辆
  var _vehicleinfoidStr = new TextEditingController();
  var _driverName = new TextEditingController(); //指定驾驶人
  var _temporaryDriver = new TextEditingController(); //临时驾驶人
  var _temporaryDriverStr = new TextEditingController(); //显示驾驶人名称
  var _assignstarttime = new TextEditingController(); //派车开始时间
  var _fixendtime = new TextEditingController(); //

  List list = new List(); //申请单集合
  int _groupValue = 0; //选中的某个资产
  bool _isExpanded = false; //panel是否展开
  _handelChange(v) {
    setState(() {
      var vd = list[v];
      _groupValue = v; //设置单选框选中的值
      _isExpanded = false; //关闭panel
      this._useVehPersonName.text = vd["chsname"];
      this._useVehPersonMobile.text = vd["appphonenumber"];
      this._usevehreason.text = vd["usevehreason"];
      this._rectime.text = vd["rectime"];
    });
  }

  List list1 = new List(); //临时驾驶员
  int _groupValue1 = 0; //选中的某个资产
  bool _isExpanded1 = false; //panel是否展开
  _handelChange1(v) {
    setState(() {
      var vd = list1[v];
      _groupValue1 = v; //设置单选框选中的值
      _isExpanded1 = false; //关闭panel
      this._temporaryDriverStr.text = vd["chsname"];
      this.temporaryDriverStr = vd["id"];
    });
  }

  List list2 = new List(); //可分派车辆
  int _groupValue2 = 0; //选中的某个资产
  bool _isExpanded2 = false; //panel是否展开
  _handelChange2(v) {
    setState(() {
      var vd = list2[v];
      _groupValue2 = v; //设置单选框选中的值
      _isExpanded2 = false; //关闭panel
      this._vehicleinfoidStr.text = vd["vehiclenumber"];
      this.vehicleinfoid = vd["id"];
      this._driverName.text = vd["chsname"] == null ? "无指定驾驶员" : vd["chsname"];
      this.driverName = vd["chsname"] == null ? "无指定驾驶员" : vd["chsname"];
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('车辆分派新增'),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(children: <Widget>[
            Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ExpansionPanelList(
                      children: <ExpansionPanel>[
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              title: Text('请选择申请单'),
                            );
                          },
                          body: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: ListBody(children: buildRadioList()),
                          ),
                          isExpanded: _isExpanded,
                          canTapOnHeader: true,
                        ),
                      ],
                      expansionCallback: (panelIndex, isExpanded) {
                        setState(() {
                          _isExpanded = !isExpanded;
                        });
                      },
                      animationDuration: kThemeAnimationDuration,
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                        new Expanded(
                          flex: 20,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: '分派编号',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._assignrecordNo,
                            onSaved: (String value) =>
                                this.assignrecordNo = value.trim(),
                          ),
                        ),
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                        new Expanded(
                          flex: 20,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: '用车人姓名',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._useVehPersonName,
                            onSaved: (String value) =>
                                this.useVehPersonName = value.trim(),
                          ),
                        ),
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                        new Expanded(
                          flex: 20,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: '用车人手机号码',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._useVehPersonMobile,
                            onSaved: (String value) =>
                                this.useVehPersonMobile = value.trim(),
                          ),
                        ),
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                        new Expanded(
                          flex: 20,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: '登记时间',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._rectime,
                            onSaved: (String value) =>
                                this.rectime = value.trim(),
                          ),
                        ),
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    ExpansionPanelList(
                      children: <ExpansionPanel>[
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              title: Text('请选择分派车辆'),
                            );
                          },
                          body: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: ListBody(children: buildRadioList2()),
                          ),
                          isExpanded: _isExpanded2,
                          canTapOnHeader: true,
                        ),
                      ],
                      expansionCallback: (panelIndex, isExpanded) {
                        setState(() {
                          _isExpanded2 = !isExpanded;
                        });
                      },
                      animationDuration: kThemeAnimationDuration,
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                        new Expanded(
                          flex: 20,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: '分派车辆',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._vehicleinfoidStr,
                            onSaved: (String value) =>
                                this.vehicleinfoidStr = value.trim(),
                          ),
                        ),
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                        new Expanded(
                          flex: 20,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: '指定驾驶人',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._driverName,
                            onSaved: (String value) =>
                                this.driverName = value.trim(),
                          ),
                        ),
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    ExpansionPanelList(
                      children: <ExpansionPanel>[
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              title: Text('请选择临时驾驶人'),
                            );
                          },
                          body: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: ListBody(children: buildRadioList1()),
                          ),
                          isExpanded: _isExpanded1,
                          canTapOnHeader: true,
                        ),
                      ],
                      expansionCallback: (panelIndex, isExpanded) {
                        setState(() {
                          _isExpanded1 = !isExpanded;
                        });
                      },
                      animationDuration: kThemeAnimationDuration,
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                        new Expanded(
                          flex: 20,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: '临时驾驶人',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._temporaryDriverStr,
                            onSaved: (String value) =>
                                this.temporaryDriverStr = value.trim(),
                          ),
                        ),
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 2,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                        new Expanded(
                          flex: 25,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: '派车时间',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._assignstarttime,
                            validator: (String value) {
                              return value.length > 0 ? null : '请选择派车时间';
                            },
                            onSaved: (String value) =>
                                this.assignstarttime = value.trim(),
                          ),
                        ),
                        new Expanded(
                          flex: 15,
                          child: new MaterialButton(
                            child: new Text('选择日期'),
                            onPressed: () {
                              // 调用函数打开
                              showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate: new DateTime.now().subtract(
                                    new Duration(days: 3000)), // 减 30 天
                                lastDate: new DateTime.now()
                                    .add(new Duration(days: 3000)), // 加 30 天
                              ).then((DateTime val) {
                                setState(() {
                                  this._assignstarttime.text =
                                      DateTimeUtil.formatDateTimeString(
                                          val.millisecondsSinceEpoch);
                                  this.assignstarttime =
                                      DateTimeUtil.formatDateTimeString(
                                          val.millisecondsSinceEpoch);
                                });
                              }).catchError((err) {
                                print(err);
                              });
                            },
                          ),
                        ),
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 2,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                        new Expanded(
                          flex: 25,
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: '返还时间',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._fixendtime,
                            validator: (String value) {
                              return value.length > 0 ? null : '请选择返还时间';
                            },
                            onSaved: (String value) =>
                                this.fixendtime = value.trim(),
                          ),
                        ),
                        new Expanded(
                          flex: 15,
                          child: new MaterialButton(
                            child: new Text('选择日期'),
                            onPressed: () {
                              // 调用函数打开
                              showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate: new DateTime.now().subtract(
                                    new Duration(days: 3000)), // 减 30 天
                                lastDate: new DateTime.now()
                                    .add(new Duration(days: 3000)), // 加 30 天
                              ).then((DateTime val) {
                                print(val.year); // 2018-07-12 00:00:00.000
                                setState(() {
                                  this._fixendtime.text =
                                      DateTimeUtil.formatDateTimeString(
                                          val.millisecondsSinceEpoch);
                                  this.fixendtime =
                                      DateTimeUtil.formatDateTimeString(
                                          val.millisecondsSinceEpoch);
                                });
                              }).catchError((err) {
                                print(err);
                              });
                            },
                          ),
                        ),
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    Divider(
                      height: 15.0,
                      color: Colors.transparent,
                    ),
                    saveOrupdateItem(),
                  ],
                )),
          ]),
        ));
  }

  Widget saveOrupdateItem(){
    if(widget.saveOrupdate){
      return Row(
        children: <Widget>[
          new Expanded(
              flex: 1,
              child: Divider(
                color: Colors.transparent,
              )),
          new Expanded(
            flex: 20,
            child: new RaisedButton(
              onPressed: () {
                print("if外");
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  //执行保存方法
                  doFrom().then((result) {
                    if (result["status"]) {
                      showToast(result["msg"]);
                      Navigator.pop(context);
                    } else {
                      showToast(result["msg"]);
                    }
                  });
                }else{
                  showToast("请将信息填写完整!");
                }
              },
              color: Colors.blue,
              child: new Text(
                '确认修改',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          new Expanded(
              flex: 1,
              child: Divider(
                color: Colors.transparent,
              )),
        ],
      );
    }else{
      return Row(
        children: <Widget>[
          new Expanded(
              flex: 1,
              child: Divider(
                color: Colors.transparent,
              )),
          new Expanded(
            flex: 20,
            child: new RaisedButton(
              onPressed: () {
                print("if外");
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  //执行保存方法
                  doFrom().then((result) {
                    if (result["status"]) {
                      showToast(result["msg"]);
                      Navigator.pop(context);
                    } else {
                      showToast(result["msg"]);
                    }
                  });
                }else{
                  showToast("请将信息填写完整!");
                }
              },
              color: Colors.blue,
              child: new Text(
                '保存',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          new Expanded(
              flex: 1,
              child: Divider(
                color: Colors.transparent,
              )),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getApply(); //获取车辆申请单
    getDriverList(); //获取临时驾驶人员
    getCarList(); //获取可分派车辆

    if(widget.saveOrupdate){// 是：修改，否：保存新增
      toInfo();

    }else{
      randomWord(); //生成随机数
      DateTime dt = new DateTime.now();
      this._rectime.text =
          DateTimeUtil.formatDateTimeString(dt.millisecondsSinceEpoch);
    }
  }


  //获取车辆分派记录
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehicleassignrecord/appFormLoad", data: {
      "id": widget.Id,
    });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    print("分派详情");
    print(result);
    setState(() {
      _assignrecordNo.text =result["applyrecordno"];
      _applyrecordid.text =result["applyrecordid"];
      _useVehPersonName.text =result["useVehPersonName"]; //用车人
      _useVehPersonMobile.text =result["useVehPersonMobile"]; //用车人手机
      _usevehreason.text =result["usevehreason"]; //用车事由
       _rectime.text =result["rectime"]; //登记时间
       _vehicleinfoid.text =result["vehicleinfoid"]; //分派车辆

       _vehicleinfoidStr.text =result["vehiclenumber"];
       _driverName.text =result["drivername"]; //指定驾驶人

       _temporaryDriver.text =result["temporaryDriver"]; //临时驾驶人
       _temporaryDriverStr.text =result["temporaryDriver"]; //显示驾驶人名称

       _assignstarttime.text =result["assignstarttime"]; //派车开始时间
       _fixendtime.text =result["fixendtime"]; //
    });
  }

  //保存车辆分派
  Future<Map> doFrom() async {
    var text;
    if(widget.saveOrupdate){
      text = '{"id":"' +
          widget.Id+
          '","assignrecordNo":"' +
          assignrecordNo +
          '","applyrecordid":"' +
          this.applyrecordid +
          '","useVehPersonName": "' +
          this.useVehPersonName +
          '","useVehPersonMobile": "' +
          this.useVehPersonMobile +
          '","rectime": "' +
          this.rectime +
          '","driverName": "' +
          this.driverName +
          '","temporaryDriver": "' +
          this.temporaryDriver +
          '","assignstarttime": "' +
          this.assignstarttime +
          '","fixendtime": "' +
          this.fixendtime +
          '","vehicleinfoid": "' +
          this.vehicleinfoid +
          '"}';
    }else{
      text = '{"assignrecordNo":"' +
          assignrecordNo +
          '","applyrecordid":"' +
          this.applyrecordid +
          '","useVehPersonName": "' +
          this.useVehPersonName +
          '","useVehPersonMobile": "' +
          this.useVehPersonMobile +
          '","rectime": "' +
          this.rectime +
          '","driverName": "' +
          this.driverName +
          '","temporaryDriver": "' +
          this.temporaryDriver +
          '","assignstarttime": "' +
          this.assignstarttime +
          '","fixendtime": "' +
          this.fixendtime +
          '","vehicleinfoid": "' +
          this.vehicleinfoid +
          '"}';
    }
    Map<String, dynamic> strJson = convert.jsonDecode(text);
    print("strJson:");
    print(strJson);
    Response result = await HttpUtil.getInstance(context).post(
        "vehicleassignrecord/appFormSave",
        data: {"strJson": text});
    return json.decode(result.data);
  }

  //获取车辆申请单
  Future<Map> getApply() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehicleapplyrecord/listLoads", data: {"status": ""});
    var result = json.decode(results.data);
    print("车辆申请单：");
    print(result);
    if (result["total"] > 0) {
      setState(() {
        this.list = result["rows"] as List;
        var vd = list[0];
        this._useVehPersonName.text = vd["chsname"];
        this._useVehPersonMobile.text = vd["appphonenumber"];
        this._usevehreason.text = vd["usevehreason"];
        this.applyrecordid = vd["id"];
      });
      print(this.list.length);
    } else {
      showToast("暂无数据!");
    }
  }

  //车辆申请单
  List<Widget> buildRadioList() {
    List<Widget> Items = [];
    Items.add(Container(
      margin: EdgeInsets.only(bottom: 4),
    ));
    for (int i = 0; i < this.list.length; i++) {
      Items.add(
        RadioListTile(
            value: i,
            title: Text(list[i]["chsname"]),
            subtitle: Text(list[i]["appphonenumber"]),
            groupValue: _groupValue,
            onChanged: _handelChange),
      );
    }
    return Items;
  }

  //获取临时驾驶人员
  Future<Map> getDriverList() async {
    Response results = await HttpUtil.getInstance(context).post(
        "vehicledriver/listLoadDriverType",
        data: {"drivertype": "temporary"});
    var result = json.decode(results.data);
    print("获取临时驾驶人员：");
    print(result);
    if (result["total"] > 0) {
      setState(() {
        this.list1 = result["rows"] as List;
        var vd = list1[0];
        this._temporaryDriverStr.text = vd["chsname"];
        this.temporaryDriver = vd["id"];
      });
      print(this.list1.length);
    } else {
      showToast("暂无数据!");
    }
  }

  //临时驾驶人
  List<Widget> buildRadioList1() {
    List<Widget> Items = [];
    Items.add(Container(
      margin: EdgeInsets.only(bottom: 4),
    ));
    for (int i = 0; i < this.list1.length; i++) {
      Items.add(
        RadioListTile(
            value: i,
            title: Text(list1[i]["chsname"]),
            groupValue: _groupValue1,
            onChanged: _handelChange1),
      );
    }
    return Items;
  }

  //获取可分派车辆
  Future<Map> getCarList() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehiclevehicleinfo/listLoadById", data: {"id": ""});
    var result = json.decode(results.data);
    print("获取可分派车辆：");
    print(result);
    if (result["total"] > 0) {
      setState(() {
        this.list2 = result["rows"] as List;
        var vd = list2[0];
        print(list2[0]["chsname"]);
        this._vehicleinfoidStr.text = vd["vehiclenumber"];
        this.vehicleinfoid = vd["id"];
        this._driverName.text =
            vd["chsname"] == null ? "无指定驾驶员" : vd["chsname"];
        this.driverName = vd["chsname"] == null ? "无指定驾驶员" : vd["chsname"];
      });
      print(this.list1.length);
    } else {
      showToast("暂无数据!");
    }
  }

  //可分派车辆
  List<Widget> buildRadioList2() {
    List<Widget> Items = [];
    Items.add(Container(
      margin: EdgeInsets.only(bottom: 4),
    ));
    for (int i = 0; i < this.list2.length; i++) {
      Items.add(
        RadioListTile(
            value: i,
            title: Text(list2[i]["vehiclenumber"]),
            subtitle: Text(list2[i]["brandtype"]),
            groupValue: _groupValue2,
            onChanged: _handelChange2),
      );
    }
    return Items;
  }

  //生成分派编号
  randomWord() {
    String alphabet = '0123456789';
    int strlenght = 18;
    /// 生成的字符串固定长度
    String left = '';
    for (var i = 0; i < strlenght; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    this.assignrecordNo = "DHFP" + left;
    this._assignrecordNo.text = "DHFP" + left;
    print(assignrecordNo);
  }
}
