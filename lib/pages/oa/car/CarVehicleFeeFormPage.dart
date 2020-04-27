import 'dart:convert';
import 'dart:core';
import 'dart:convert' as convert;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';

class CarVehicleFeeFormPage extends StatefulWidget {
  final bool saveOrupdate;
  final String Id;
  CarVehicleFeeFormPage(this.saveOrupdate,{this.Id}) : super();
  @override
  _CarVehicleFeeFormPageState createState() =>
      _CarVehicleFeeFormPageState();
}

class _CarVehicleFeeFormPageState
    extends State<CarVehicleFeeFormPage> {

  String title="添加车辆费用";

  List list =new List();//所有费用类型

  String feerecpersonname=""; //登记人名称
  String feetype=""; //费用类型id
  String feevalue=""; //金额(元)
  String feedate=""; //费用日期
  String remark=""; //备注
  String feetypeid="";//修改费用类型id

  // (费用类型选择：机动车保险单 显示，需要填写的信息)
  String theinsured=""; //被保险人
  String theinsurednumber=""; //证件号码
  String theinsuredaddress=""; //住址
  String theinsuredphonenumber=""; //联系方式
  String vehiclenumber=""; //车辆号牌号码
  String vehiclemodel=""; //车辆厂牌型号
  String vin=""; //车架号
  String vinnumber=""; //车辆VIN码
  String enginenumber=""; //发动机号
  String nature=""; //使用性质
  String registerdate=""; //初次登记日期
  String vehicletype=""; //车辆类型
  String agelimit=""; //已使用年限
  String seatingcapacity=""; //核定载客人数
  String quality=""; //核定载质量
  String travelowner=""; //行驶证车主
  String travelarea=""; //行驶区域
  String insurancetime=""; //保险期间
  String solveway=""; //保险合同争议解决方式
  String companyname=""; //保险人公司名称
  String insurancephonenumber=""; //保险人电话号码
  String companyaddress=""; //保险人公司住址
  String zipcode=""; //保险人邮政编码
  String writtenpermissiondate=""; //签单日期
  String underwriting=""; //核保
  String preparedocument=""; //制单
  String handle=""; //经办
  String specialagreement=""; //特别约定
  String hint=""; //重要提示

  //是否显示保险单信息
  bool _isitem=false;

  //通过controller   给输入框默认值
  var _feedate = new TextEditingController();
  var _feerecpersonname = new TextEditingController();
  var _feetype = new TextEditingController();
  var _feevalue=new TextEditingController(); //金额(元)
  var _remark=new TextEditingController(); //备注

  // (费用类型选择：机动车保险单 显示，需要填写的信息)
  var _theinsured=new TextEditingController(); //被保险人
  var _theinsurednumber=new TextEditingController(); //证件号码
  var _theinsuredaddress=new TextEditingController(); //住址
  var _theinsuredphonenumber=new TextEditingController(); //联系方式
  var _vehiclenumber=new TextEditingController(); //车辆号牌号码
  var _vehiclemodel=new TextEditingController(); //车辆厂牌型号
  var _vin=new TextEditingController(); //车架号
  var _vinnumber=new TextEditingController(); //车辆VIN码
  var _enginenumber=new TextEditingController(); //发动机号
  var _nature=new TextEditingController(); //使用性质
  var _vehicletype=new TextEditingController(); //车辆类型
  var _agelimit=new TextEditingController(); //已使用年限
  var _seatingcapacity=new TextEditingController(); //核定载客人数
  var _quality=new TextEditingController(); //核定载质量
  var _travelowner=new TextEditingController(); //行驶证车主
  var _travelarea=new TextEditingController(); //行驶区域
  var _insurancetime=new TextEditingController(); //保险期间
  var _solveway=new TextEditingController(); //保险合同争议解决方式
  var _companyname=new TextEditingController(); //保险人公司名称
  var _insurancephonenumber=new TextEditingController(); //保险人电话号码
  var _companyaddress=new TextEditingController(); //保险人公司住址
  var _zipcode=new TextEditingController(); //保险人邮政编码
  var _writtenpermissiondate=new TextEditingController(); //签单日期
  var _underwriting=new TextEditingController(); //核保
  var _preparedocument=new TextEditingController(); //制单
  var _handle=new TextEditingController(); //经办
  var _specialagreement=new TextEditingController(); //特别约定
  var _hint=new TextEditingController(); //重要提示

  //
  var _registerdate = new TextEditingController();

  bool _isExpanded = false; //panel是否展开
  int _groupValue = 0; //选中的某个资产

  _handelChange(v) {
    setState(() {
      var vd = list[v];
      this._feetype.text = vd["name"];
      this.feetype=vd["id"];
      _groupValue=v;
      _isExpanded=false;
      if(vd["name"]=="机动车保险单"){
        _isitem=true;
      }else{
        _isitem=false;
      }
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
              ExpansionPanelList(
                children: <ExpansionPanel>[
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: Text('请选择费用类型'),
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
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                  new Expanded(
                    flex: 20,
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: '费用类型',
                        contentPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 0, right: 0),
                      ),
                      keyboardType: TextInputType.text,
                      controller: this._feetype,
                      validator: (String value) {
                        return value.length > 0 ? null : '请选择费用类型';
                      },
                    ),
                  ),
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                ],
              ),
              Divider(
                height: 15.0,
                color: Colors.transparent,
              ),
              Row(
                children: <Widget>[
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                  new Expanded(
                    flex: 20,
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: '登记人名称',
                        contentPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 0, right: 0),
                      ),
                      keyboardType: TextInputType.text,
                      controller: this._feerecpersonname,
                      onSaved: (String value) =>
                          this.feerecpersonname = value.trim(),
                    ),
                  ),
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                ],
              ),
              Divider(
                height: 15.0,
                color: Colors.transparent,
              ),
              Row(
                children: <Widget>[
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                  new Expanded(
                    flex: 20,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '金额(元)',
                        contentPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 0, right: 0),
                      ),
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9]")), //只能输入汉字或者字母或数字
                        LengthLimitingTextInputFormatter(10),//最大长度
                      ],
                      keyboardType: TextInputType.text,
                      controller: this._feevalue,
                      validator: (String value) {
                        return value.length > 0 ? null : '请输入金额';
                      },
                      onSaved: (String value) => this.feevalue = value.trim(),
                    ),
                  ),
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                ],
              ),
              Divider(
                height: 15.0,
                color: Colors.transparent,
              ),
              Row(
                children: <Widget>[
                  new Expanded(flex:2,child: Divider(color: Colors.transparent,)),
                  new Expanded(
                    flex: 25,
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: '费用日期',
                        contentPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 0, right: 0),
                      ),
                      keyboardType: TextInputType.text,
                      controller: this._feedate,
                      validator: (String value) {
                        return value.length > 0 ? null : '请选择费用日期';
                      },
                      onSaved: (String value) => this.feedate = value.trim(),
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
                              .subtract(new Duration(days: 3000)), // 减 30 天
                          lastDate: new DateTime.now()
                              .add(new Duration(days: 3000)), // 加 30 天
                        ).then((DateTime val) {
                          print(val.year); // 2018-07-12 00:00:00.000

                          int month=val.month;
                          String months="";
                          if(month<=9){
                            months="0"+month.toString();
                          }else{
                            months=month.toString();
                          }
                          int days=val.day;
                          String dayss="";
                          if(days<=9){
                            dayss="0"+days.toString();
                          }else{
                            dayss=days.toString();
                          }
                          String date=val.year.toString()+'-'+months+"-"+dayss;
                          setState(() {
                            this._feedate.text = date;
                            this.feedate = date;
                          });
                        }).catchError((err) {
                          print(err);
                        });
                      },
                    ),
                  ),
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                ],
              ),
              Divider(
                height: 15.0,
                color: Colors.transparent,
              ),
              Row(
                children: <Widget>[
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                  new Expanded(
                    flex: 20,
                    child: TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: '备注',
                        contentPadding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 0, right: 0),
                      ),
                      keyboardType: TextInputType.text,
                      controller: this._remark,
                      validator: (String value) {
                        return value.length > 0 ? null : '请输入处置原因';
                      },
                      onSaved: (String value) => this.remark = value.trim(),
                    ),
                  ),
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                ],
              ),
              Divider(
                height: 20.0,
                color: Colors.transparent,
              ),
              feeitem(),
              Row(
                children: <Widget>[
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                  new Expanded(
                    flex: 20,
                    child:saveOrupdateItem(),
                  ),
                  new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
                ],
              ),
            ],
          ),
        ));
  }

  //保存车辆处置
  Future<Map> doFrom() async {
    var text;
    if(widget.saveOrupdate){
      text = '{"feerecpersonname":"' +
          _feerecpersonname.text +
          '","feetype":"' +
          this.feetype +
          '","feevalue": "' +
          this._feevalue.text +
          '","feedate": "' +
          this._feedate.text +
          '","remark": "' +
          this._remark.text +
          '","theinsured": "' +
          this._theinsured.text +
          '","theinsurednumber": "' +
          this._theinsurednumber.text +
          '","theinsuredaddress": "' +
          this._theinsuredaddress.text +
          '","theinsuredphonenumber": "' +
          this._theinsuredphonenumber.text +
          '","vehiclenumber": "' +
          this._vehiclenumber.text +
          '","vehiclemodel": "' +
          this._vehiclemodel.text +
          '","vin": "' +
          this._vin.text +
          '","vinnumber": "' +
          this._vinnumber.text +
          '","enginenumber": "' +
          this._enginenumber.text +
          '","nature": "' +
          this._nature.text +
          '","registerdate": "' +
          this._registerdate.text +
          '","vehicletype": "' +
          this._vehicletype.text +
          '","agelimit": "' +
          this._agelimit.text +
          '","seatingcapacity": "' +
          this._seatingcapacity.text +
          '","quality": "' +
          this._quality.text +
          '","travelowner": "' +
          this._travelowner.text +
          '","travelarea": "' +
          this._travelarea.text +
          '","insurancetime": "' +
          this._insurancetime.text +
          '","solveway": "' +
          this._solveway.text +
          '","companyname": "' +
          this._companyname.text +
          '","insurancephonenumber": "' +
          this._insurancephonenumber.text +
          '","companyaddress": "' +
          this._companyaddress.text +
          '","zipcode": "' +
          this._zipcode.text +
          '","writtenpermissiondate": "' +
          this._writtenpermissiondate.text +
          '","underwriting": "' +
          this._underwriting.text +
          '","preparedocument": "' +
          this._preparedocument.text +
          '","handle": "' +
          this._handle.text +
          '","specialagreement": "' +
          this._specialagreement.text +
          '","hint": "' +
          this._hint.text +
          '","id": "' +
          widget.Id +
          '","feetypeid": "'+this.feetypeid+'"}';
    }else{
      text = '{"feerecpersonname":"' +
          feerecpersonname +
          '","feetype":"' +
          this.feetype +
          '","feevalue": "' +
          this._feevalue.text +
          '","feedate": "' +
          this.feedate +
          '","remark": "' +
          this._remark.text +
          '","theinsured": "' +
          this.theinsured +
          '","theinsurednumber": "' +
          this.theinsurednumber +
          '","theinsuredaddress": "' +
          this.theinsuredaddress +
          '","theinsuredphonenumber": "' +
          this.theinsuredphonenumber +
          '","vehiclenumber": "' +
          this.vehiclenumber +
          '","vehiclemodel": "' +
          this.vehiclemodel +
          '","vin": "' +
          this.vin +
          '","vinnumber": "' +
          this.vinnumber +
          '","enginenumber": "' +
          this.enginenumber +
          '","nature": "' +
          this.nature +
          '","registerdate": "' +
          this.registerdate +
          '","vehicletype": "' +
          this.vehicletype +
          '","agelimit": "' +
          this.agelimit +
          '","seatingcapacity": "' +
          this.seatingcapacity +
          '","quality": "' +
          this.quality +
          '","travelowner": "' +
          this.travelowner +
          '","travelarea": "' +
          this.travelarea +
          '","insurancetime": "' +
          this.insurancetime +
          '","solveway": "' +
          this.solveway +
          '","companyname": "' +
          this.companyname +
          '","insurancephonenumber": "' +
          this.insurancephonenumber +
          '","companyaddress": "' +
          this.companyaddress +
          '","zipcode": "' +
          this.zipcode +
          '","writtenpermissiondate": "' +
          this.writtenpermissiondate +
          '","underwriting": "' +
          this.underwriting +
          '","preparedocument": "' +
          this.preparedocument +
          '","handle": "' +
          this.handle +
          '","specialagreement": "' +
          this.specialagreement +
          '","hint": "' +
          this.hint +
          '"}';
    }
    Map<String, dynamic> strJson = convert.jsonDecode(text);
    print(widget.saveOrupdate);
    print(strJson);
    Response result = await HttpUtil.getInstance(context)
        .post("vehiclefee/formSaves", data: strJson);
    return json.decode(result.data);
  }

  Widget feeitem(){
    if(!_isitem){
      return Container(child: Text(""),);
    }
    else{
      return Column(children: <Widget>[
        Container(
          color: Colors.blue,
          height: 50,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 0, bottom: 10, left: 15, right: 3),
          child: Text(
            '机动车辆保险信息单',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              letterSpacing: 2.0,
            ),
          ),
        ),
        Divider(
          height: 15.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '被保险人',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._theinsured,
                onSaved: (String value) => this.theinsured = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '证件号码',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._theinsurednumber,
                onSaved: (String value) => this.theinsurednumber = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '住址',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._theinsuredaddress,
                onSaved: (String value) => this.theinsuredaddress = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '联系方式',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._theinsuredphonenumber,
                onSaved: (String value) => this.theinsuredphonenumber = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '车辆号牌号码',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._vehiclenumber,
                onSaved: (String value) => this.vehiclenumber = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '车辆厂牌型号',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._vehiclemodel,
                onSaved: (String value) => this.vehiclemodel = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '车架号',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._vin,
                onSaved: (String value) => this.vin = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '车辆VIN码',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._vinnumber,
                onSaved: (String value) => this.vinnumber = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '发动机号',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._enginenumber,
                onSaved: (String value) => this.enginenumber = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '使用性质',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._nature,
                onSaved: (String value) => this.nature = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:2,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 25,
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: '初次登记日期',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._registerdate,
                validator: (String value) {
                  return value.length > 0 ? null : '请选择费用日期';
                },
                onSaved: (String value) => this.registerdate = value.trim(),
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
                        .subtract(new Duration(days: 3000)), // 减 30 天
                    lastDate: new DateTime.now()
                        .add(new Duration(days: 3000)), // 加 30 天
                  ).then((DateTime val) {
                    print(val); // 2018-07-12 00:00:00.000

                    int month=val.month;
                    String months="";
                    if(month<=9){
                      months="0"+month.toString();
                    }else{
                      months=month.toString();
                    }
                    int days=val.day;
                    String dayss="";
                    if(days<=9){
                      dayss="0"+days.toString();
                    }else{
                      dayss=days.toString();
                    }
                    String date=val.year.toString()+'-'+months+"-"+dayss;
                    setState(() {
                      this._registerdate.text = date;
                      this.registerdate= date;
                    });
                  }).catchError((err) {
                    print(err);
                  });
                },
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '车辆类型',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._vehicletype,
                onSaved: (String value) => this.vehicletype = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '已使用年限',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._agelimit,
                onSaved: (String value) => this.agelimit = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '核定载客人数',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._seatingcapacity,
                onSaved: (String value) => this.seatingcapacity = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '核定载质量',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._quality,
                onSaved: (String value) => this.quality = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '行驶证车主',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._travelowner,
                onSaved: (String value) => this.travelowner = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '行驶区域',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._travelarea,
                onSaved: (String value) => this.travelarea = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '保险期间',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._insurancetime,
                onSaved: (String value) => this.insurancetime = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '保险合同争议解决方式',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._solveway,
                onSaved: (String value) => this.solveway = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '保险人公司名称',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._companyname,
                onSaved: (String value) => this.companyname = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '保险人电话号码',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._insurancephonenumber,
                onSaved: (String value) => this.insurancephonenumber = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '保险人公司住址',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._companyaddress,
                onSaved: (String value) => this.companyaddress = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '保险人邮政编码',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._zipcode,
                onSaved: (String value) => this.zipcode = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '签单日期',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._writtenpermissiondate,
                onSaved: (String value) => this.writtenpermissiondate = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '核保',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._underwriting,
                onSaved: (String value) => this.underwriting = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '制单',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._preparedocument,
                onSaved: (String value) => this.preparedocument = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '经办',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._handle,
                onSaved: (String value) => this.handle = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '特别约定',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._specialagreement,
                onSaved: (String value) => this.specialagreement = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Row(
          children: <Widget>[
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
            new Expanded(
              flex: 20,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '重要提示',
                  contentPadding: EdgeInsets.only(
                      top: 0, bottom: 0, left: 0, right: 0),
                ),
                keyboardType: TextInputType.text,
                controller: this._hint,
                onSaved: (String value) => this.hint = value.trim(),
              ),
            ),
            new Expanded(flex:1,child: Divider(color: Colors.transparent,)),
          ],
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),

      ],);
    }
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
            title: Text(list[i]["name"]),
            groupValue: _groupValue,
            onChanged: _handelChange),
      );
    }
    return Items;
  }


  @override
  void initState() {
    super.initState();
    feetypeList();
    loadUserInfo();//获取登录信息
    print(widget.saveOrupdate);
    if(widget.saveOrupdate){
     toInfo();
    }
  }

  //获取费用类型
  Future<Map> feetypeList() async {
    Response results = await HttpUtil.getInstance(context)
        .post("appContract/listsystems?type=business&code=carFeeType", data: {"id": ""});
    var result = json.decode(results.data);
    print("费用类型：");
    print(result);
    if (result["total"] > 0) {
      setState(() {
        this.list = result["rows"] as List;
        if(!widget.saveOrupdate){
          var vd = list[0];
          this._feetype.text = vd["name"];
          this.feetype=vd["id"];
        }
      });
      print(this.list.length);
    } else {
      showToast("请稍后尝试!");
    }
  }

  void loadUserInfo()async{
    await AuthUtil.getUserInfo().then((userInfo) {
      setState(() {
        this._feerecpersonname.text = userInfo.chsname == null ? "" : userInfo.chsname;
        this.feerecpersonname = userInfo.chsname == null ? "" : userInfo.chsname;

      });
    });
  }

  Widget saveOrupdateItem(){
    if(widget.saveOrupdate){
      setState(() {
        title="修改车辆费用";
      });
      return  new RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            //执行保存方法
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
        title="添加车辆费用";
      });
      return  new RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            //执行保存方法
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

  //获取车辆费用详情记录
  Future<Map> toInfo() async {
    Response results = await HttpUtil.getInstance(context)
        .post("vehiclefee/appFormLoad", data: {
      "id": widget.Id,
    });
    print("id:" + widget.Id);
    var result = json.decode(results.data);
    print("费用详情");
    print(result);
    setState(() {
//通过controller   给输入框默认值
      _feedate.text =result["feedate"];
      _feerecpersonname.text =result["feerecpersonname"];
       _feetype.text =result["feetypename"];
       feetype=result["feetype"];
       _feevalue.text =result["feevalue"]; //金额(元)
       _remark.text =result["remark"]; //备注

      if(_feetype.text=="机动车保险单"){
        _isitem=true;
      }
      // (费用类型选择：机动车保险单 显示，需要填写的信息)
       _theinsured.text =result["theinsured"]; //被保险人
       _theinsurednumber.text =result["theinsurednumber"]; //证件号码
       _theinsuredaddress.text =result["theinsuredaddress"]; //住址
       _theinsuredphonenumber.text =result["theinsuredphonenumber1"]; //联系方式
       _vehiclenumber.text =result["vehiclenumber"]; //车辆号牌号码
       _vehiclemodel.text =result["vehiclemodel"]; //车辆厂牌型号
       _vin.text =result["vin"]; //车架号1
       _vinnumber.text =result["vinnumber"]; //车辆VIN码
       _enginenumber.text =result["enginenumber"]; //发动机号
       _nature.text =result["nature"]; //使用性质
       _vehicletype.text =result["vehicletype"]; //车辆类型
       _agelimit.text =result["agelimit"]; //已使用年限
       _seatingcapacity.text =result["seatingcapacity"]; //核定载客人数
       _quality.text =result["quality"]; //核定载质量
       _travelowner.text =result["travelowner"]; //行驶证车主
       _travelarea.text =result["travelarea"]; //行驶区域
       _insurancetime.text =result["insurancetime"]; //保险期间
       _solveway.text =result["solveway"]; //保险合同争议解决方式
       _companyname.text =result["companyname"]; //保险人公司名称
       _insurancephonenumber.text =result["insurancephonenumber"]; //保险人电话号码
       _companyaddress.text =result["companyaddress"]; //保险人公司住址
       _zipcode.text =result["zipcode"]; //保险人邮政编码
       _writtenpermissiondate.text =result["writtenpermissiondate"]; //签单日期
       _underwriting.text =result["underwriting"]; //核保
       _preparedocument.text =result["preparedocument"]; //制单
       _handle.text =result["handle"]; //经办
       _specialagreement.text =result["specialagreement"]; //特别约定
       _hint.text =result["hint"]; //重要提示
      _registerdate.text=DateTimeUtil.formatDateString(result["registerdate"]);

      feerecpersonname=result["feerecpersonname"]; //登记人名称
      feevalue=result["feevalue"]; //金额(元)
      feedate=result["feedate"]; //费用日期
      remark=result["remark"]; //备注

      feetypeid=result["feetypeid"];

      // (费用类型选择：机动车保险单 显示，需要填写的信息)
      theinsured=result["theinsured"]; //被保险人
      theinsurednumber=result["theinsurednumber"]; //证件号码
      theinsuredaddress=result["theinsuredaddress"]; //住址
      theinsuredphonenumber=result["theinsuredphonenumber"]; //联系方式
      vehiclenumber=result["vehiclenumber"]; //车辆号牌号码
      vehiclemodel=result["vehiclemodel"]; //车辆厂牌型号
      vin=result["vin"]; //车架号
      vinnumber=result["vinnumber"]; //车辆VIN码
      enginenumber=result["enginenumber"]; //发动机号
      nature=result["nature"]; //使用性质
      registerdate=result["registerdate"]; //初次登记日期
      vehicletype=result["vehicletype"]; //车辆类型
      agelimit=result["agelimit"]; //已使用年限
      seatingcapacity=result["seatingcapacity"]; //核定载客人数
      quality=result["quality"]; //核定载质量
      travelowner=result["travelowner"]; //行驶证车主
      travelarea=result["travelarea"]; //行驶区域
      insurancetime=result["insurancetime"]; //保险期间
      solveway=result["solveway"]; //保险合同争议解决方式
      companyname=result["companyname"]; //保险人公司名称
      insurancephonenumber=result["insurancephonenumber"]; //保险人电话号码
      companyaddress=result["companyaddress"]; //保险人公司住址
      zipcode=result["zipcode"]; //保险人邮政编码
      writtenpermissiondate=result["writtenpermissiondate"]; //签单日期
      underwriting=result["underwriting"]; //核保
      preparedocument=result["preparedocument"]; //制单
      handle=result["handle"]; //经办
      specialagreement=result["specialagreement"]; //特别约定
      hint=result["hint"]; //重要提示
    });
  }
}
