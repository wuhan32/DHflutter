import 'dart:convert';
import 'dart:convert' as convert;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class CarVehicleDisposalFormPage extends StatefulWidget {
  final bool saveOrupdate;
  final String Id;
  CarVehicleDisposalFormPage(this.saveOrupdate,{this.Id}) : super();
  @override
  _CarVehicleDisposalFormPageState createState() =>
      _CarVehicleDisposalFormPageState();
}

class _CarVehicleDisposalFormPageState
    extends State<CarVehicleDisposalFormPage> {

  String title="添加车辆处置";

  List list = new List(); //所有资产信息-车辆
  List list1 = new List(); //处置性质

  String assetnumber = ""; //资产编号id
  String vehiclenumber = ""; //车牌号码
  String brandtype = ""; //品牌类型
  String recpersonname = ""; //登记人名称
  String disstate = ""; //处置性质id
  String disdate = ""; //处置日期
  String remark = ""; //描述
  String disreason = ""; //处置原因

  bool _isExpanded = false; //panel是否展开
  //通过controller   给输入框默认值
  var _assetnumber = new TextEditingController(); //资产编号id
  var _vehiclenumber = new TextEditingController(); //车牌号码
  var _brandtype = new TextEditingController(); //品牌类型
  var _disdate = new TextEditingController(); //处置日期
  int _groupValue = 0; //选中的某个资产
  var _remark = new TextEditingController(); //描述
  var _disreason = new TextEditingController(); //处置原因

  _handelChange(v) {
    setState(() {
      var vd = list[v];
      this._assetnumber.text = vd["assetnumber"];
      this._vehiclenumber.text = vd["vehiclenumber"];
      this._brandtype.text = vd["brandtype"];
      _groupValue = v; //设置单选框选中的值
      _isExpanded = false; //关闭panel
    });
  }

  int _groupValue1 = 0; //选中的某个资产
  bool _isExpanded1 = false; //panel是否展开
  var _disstate = new TextEditingController(); //处置性质id

  _handelChange1(v) {
    setState(() {
      var vd = list1[v];
      _isExpanded1 = false; //关闭panel
      this._disstate.text = vd["name"];
      this.disstate = vd["id"];
      _groupValue1 = v; //设置单选框选中的值
      _isExpanded1 = false; //关闭panel
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text(title),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
//            padding: EdgeInsets.only(top: 0, bottom: 20, left: 15, right: 15),
            children: <Widget>[
              Container(
                  color: Colors.white,
                  child: Column(children: <Widget>[
                    ExpansionPanelList(
                      children: <ExpansionPanel>[
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              title: Text('请选择资产'),
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
                              labelText: '资产编号',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._assetnumber,
                            validator: (String value) {
                              return value.length > 0 ? null : '请选择资产';
                            },
                            onSaved: (String value) =>
                                this.assetnumber = value.trim(),
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
                              labelText: '车牌号码',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._vehiclenumber,
                            validator: (String value) {
                              return value.length > 0 ? null : '请选择资产';
                            },
                            onSaved: (String value) =>
                                this.vehiclenumber = value.trim(),
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
                              labelText: '品牌类型',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._brandtype,
                            validator: (String value) {
                              return value.length > 0 ? null : '请选择资产';
                            },
                            onSaved: (String value) =>
                                this.brandtype = value.trim(),
                          ),
                        ),
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    ExpansionPanelList(
                      children: <ExpansionPanel>[
                        ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              title: Text('请选择处置性质'),
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
                            enabled: true,
                            decoration: InputDecoration(
                              labelText: '处置性质',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._disstate,
                            validator: (String value) {
                              return value.length > 0 ? null : '请选择处置性质';
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
                            enabled: true,
                            decoration: InputDecoration(
                              labelText: '处置日期',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._disdate,
                            validator: (String value) {
                              return value.length > 0 ? null : '请选择处置日期';
                            },
                            onSaved: (String value) =>
                                this.disdate = value.trim(),
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
                                firstDate: new DateTime.now()
                                    .subtract(new Duration(days: 30)), // 减 30 天
                                lastDate: new DateTime.now()
                                    .add(new Duration(days: 30)), // 加 30 天
                              ).then((DateTime val) {
                                print(val); // 2018-07-12 00:00:00.000
                                setState(() {
                                  this._disdate.text =  DateTimeUtil.formatDateString(
                                      val.millisecondsSinceEpoch);
                                  this.disdate= DateTimeUtil.formatDateString(
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
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                        new Expanded(
                          flex: 20,
                          child: TextFormField(
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: '处置原因',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._disreason,
                            validator: (String value) {
                              return value.length > 0 ? null : '请输入处置原因';
                            },
                            onSaved: (String value) =>
                                this.disreason = value.trim(),
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
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: '描述',
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0),
                            ),
                            keyboardType: TextInputType.text,
                            controller: this._remark,
                            onSaved: (String value) =>
                                this.remark = value.trim(),
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
                      height: 20.0,
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
                          child:saveOrupdateItem()
                        ),
                        new Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                  ])),
            ],
          ),
        ));
  }

  Widget saveOrupdateItem(){
    if(widget.saveOrupdate){
      setState(() {
        title="修改车辆处置";
      });
      return  new RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            //执行保存方法
            print("disstate:" + this.disstate);
            doFrom().then((result) {
              print("dofromresult:");
              print(result);
              if (result["status"]) {
                showToast(result["msg"]);
                Navigator.pop(context);
              } else {
                showToast(result["msg"]);
              }
            });
          }
        },
        color: Colors.blue,
        child: new Text(
          '修改',
          style: TextStyle(color: Colors.white),
        ),
      );
    }else{
      setState(() {
        title="添加车辆处置";
      });
      return  new RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            //执行保存方法
            print("disstate:" + this.disstate);
            doFrom().then((result) {
              print("dofromresult:");
              print(result);
              if (result["status"]) {
                showToast(result["msg"]);
                Navigator.pop(context);
              } else {
                showToast(result["msg"]);
              }
            });
          }
        },
        color: Colors.blue,
        child: new Text(
          '保存',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  //保存车辆处置
  Future<Map> doFrom() async {
    var text;
    if(widget.saveOrupdate){
      text = '{"assetnumber":"' +
          assetnumber +
          '","vehiclenumber":"' +
          this.vehiclenumber +
          '","brandtype": "' +
          this.brandtype +
          '","recpersonname": "' +
          this.recpersonname +
          '","disstate": "' +
          this.disstate +
          '","disdate": "' +
          this.disdate +
          '","remark": "' +
          this.remark +
          '","disreason": "' +
          this.disreason +
          '","ext1": "","ext2": "","ext3": "","recpersonid": "","vehicleid": "","id": "' +
          widget.Id +
          '"}';
    }else{
      text = '{"assetnumber":"' +
          assetnumber +
          '","vehiclenumber":"' +
          this.vehiclenumber +
          '","brandtype": "' +
          this.brandtype +
          '","recpersonname": "' +
          this.recpersonname +
          '","disstate": "' +
          this.disstate +
          '","disdate": "' +
          this.disdate +
          '","remark": "' +
          this.remark +
          '","disreason": "' +
          this.disreason +
          '","ext1": "","ext2": "","ext3": "","recpersonid": "","vehicleid": ""}';
    }
    Map<String, dynamic> strJson = convert.jsonDecode(text);
    Response result = await HttpUtil.getInstance(context)
        .post("vehicledisposal/formSave", data:strJson);
    return json.decode(result.data);
  }

  //构建列表
  List<Widget> buildRadioList() {
    List<Widget> Items = [];
    Items.add(Container(
      margin: EdgeInsets.only(bottom: 4),
    ));
    for (int i = 0; i < this.list.length; i++) {
      Items.add(
        RadioListTile(
            value: i,
            title: Text(list[i]["vehiclenumber"]),
            subtitle: Text(list[i]["brandtype"]),
            groupValue: _groupValue,
            onChanged: _handelChange),
      );
    }
    return Items;
  }

  @override
  void initState() {
    super.initState();
    carList();
    loadUserInfo(); //获取登录信息
    cardistateList();
    if(widget.saveOrupdate){
      toInfo();
    }
  }

  //获取车辆分派记录
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehicledisposal/appFormLoad", data: {
      "id": widget.Id,
    });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    print("车辆处置详情");
    print(result);
    if (result != null) {
      setState(() {
        _assetnumber.text =result["assetnumber"]== null ? result["assetnumberid"]==null ? "" :result["assetnumberid"] : result["assetnumber"]; //资产编号id
        _vehiclenumber.text =result["vehiclenumber"]; //车牌号码
        _brandtype.text =result["brandtype"]; //品牌类型
        _disdate.text =result["disdate"]; //处置日期
        _remark.text =result["remark"]; //描述
        _disreason.text =result["disreason"]; //处置原因
      });
    } else {
      showToast("请稍后尝试!");
    }
  }

  //获取所有车辆信息
  Future<Map> carList() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehiclevehicleinfo/listLoad", data: {"id": ""});
    var result = json.decode(results.data);
    print("车辆资产：");
    if (result["total"] > 0) {
      setState(() {
        this.list = result["rows"] as List;
        var vd = list[0];
        this._assetnumber.text = vd["assetnumber"];
        this._vehiclenumber.text = vd["vehiclenumber"];
        this._brandtype.text = vd["brandtype"];
      });
      print(this.list.length);
    } else {
      showToast("请稍后尝试!");
    }
  }

  //构建处置性质列表
  List<Widget> buildRadioList1() {
    List<Widget> Items = [];
    Items.add(Container(
      margin: EdgeInsets.only(bottom: 4),
    ));
    for (int i = 0; i < this.list1.length; i++) {
      Items.add(
        RadioListTile(
            value: i,
            title: Text(list1[i]["name"]),
            groupValue: _groupValue1,
            onChanged: _handelChange1),
      );
    }
    return Items;
  }

  //获取处置性质
  Future<Map> cardistateList() async {
    Response results = await HttpUtil.getInstance(context).post(
        "appContract/listsystems?type=business&code=cp1561336775520",
        data: {"id": ""});
    var result = json.decode(results.data);
    print("处置性质：");
    print(result);
    if (result["total"] > 0) {
      setState(() {
        this.list1 = result["rows"] as List;
        var vd = list1[0];
        this._disstate.text = vd["name"];
        this.disstate = vd["id"];
      });
      print(this.list1.length);
    } else {
      showToast("请稍后尝试!");
    }
  }

  void loadUserInfo() async {
    await AuthUtil.getUserInfo().then((userInfo) {
      setState(() {
        this.recpersonname =
            userInfo.chsname== null ? "" : userInfo.chsname;
      });
    });
  }
}
