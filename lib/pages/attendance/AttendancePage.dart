import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bdmap_location_flutter_plugin/bdmap_location_flutter_plugin.dart';
import 'package:bdmap_location_flutter_plugin/flutter_baidu_location.dart';
import 'package:bdmap_location_flutter_plugin/flutter_baidu_location_android_option.dart';
import 'package:bdmap_location_flutter_plugin/flutter_baidu_location_ios_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/components/MyFloatingActionButtonLocation.dart';
import 'package:oa/pages/attendance/SignRecord.dart';
import 'package:oa/utils/AudioPlayerUtil.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

//打卡考勤
class AttendancePage extends StatefulWidget {
  @override
  AttendancePageState createState() => new AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {

  WebViewController _controller;
  //百度地图定位插件
  LocationFlutterPlugin locationPlugin = new LocationFlutterPlugin();
  //百度地图定位监听
  StreamSubscription<Map<String, Object>> locationListener;
  //定位返回结果
  BaiduLocation bdMapLocation;
  //当前位置纬度
  double userCurrentLatitude;
  //当前位置经度
  double userCurrentLongitude;
  //位置刷新时间
  String refreshTime = DateTimeUtil.formatDateTimeString(DateTime.now().millisecondsSinceEpoch);
  //考勤位置
  String signInAddress;
  //考勤详细位置
  String signInLocationDetail;
  //考勤纬度
  double signInLatitude;
  //考勤经度
  double signInLongitude;
  //考勤范围
  double signInScope;
  //到考勤地点的距离
  double signInDistance;
  //打卡按钮点击事件
  Function signButtonEvent;
  //考勤班次
  List<Widget> signShifts = [];
  //ios定时刷新定时器
  Timer iosFlushLocationTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Center(
          child: Text('考勤'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.receipt),
            onPressed: () {
              //查看打卡记录
              iosFlushLocationTimer?.cancel();
              stopLocation();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SignRecordPage();
              })).then((_){
                  startTimer();
              });
            },
          )
        ],
      ),
      body: new Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("温馨提示 :", style: TextStyle(color: Colors.red)),
                  Text("请预先打开GPS,WIFI,数据流量",style: TextStyle(color: Colors.redAccent))
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Expanded(
              flex: 2,
              child: Container(
                child: Card(
                  elevation: 1,
                  margin: EdgeInsets.all(0),
                  child: ListTile(
                    isThreeLine: false,
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.straighten, color: Colors.red),
                        Text(
                          "打卡距离",
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                    title: Text(
                      this.signInDistance == null
                          ? "定位中...."
                          : distanceConversion(),
                      style: TextStyle(
                          color: this.signInDistance == null ||
                              (this.signInDistance > this.signInScope)
                              ? Colors.red
                              : Colors.green),
                    ),
                    subtitle: Text(
                      "刷新时间 : " + this.refreshTime,
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          reStartLocation();
                        }),
                  ),
                ),
              )
          ),
          Expanded(
              flex: 2,
              child: Container(
                child: Card(
                  margin: EdgeInsets.all(0),
                  elevation: 1,
                  child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.my_location, color: Colors.red),
                        Text(
                          "考勤位置",
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                    title:Text(signInAddress == null ? "加载中..." : signInAddress),
                    subtitle: Text(this.signInLocationDetail==null?"":this.signInLocationDetail),
                  ),
                ),
              )),
          Expanded(
              flex:2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: signShifts,
              )),
          Expanded(
              flex: 10,
              child: Container(
                height: 300,
                child: WebView(
                    initialUrl: "http://www.dahengzh.com/app/bdmap.html",
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (controller) {
                      _controller = controller;
                    },
                ),
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            signButtonEvent == null ? Colors.grey : Colors.lightBlue,
        child: Center(
          child: Text("打卡",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        ),
        onPressed: signButtonEvent,
      ),
      floatingActionButtonLocation:
          MyFloatingActionButtonLocation(xCoefficient: 0.5),
    );
  }



  void startAMapLocation() async {
    try {
      //加载用户打卡位置信息
      loadUserSignLocation().then((value) {
        locationPlugin.requestPermission();
        /// 动态申请定位权限
        if (Platform.isIOS) {
          //设置百度地图apikey
          LocationFlutterPlugin.setApiKey("4SMtKWGeDhgUX4RTWRp6Qm49BPuKZlhG");
        }
        locationListener = locationPlugin
            .onResultCallback()
            .listen((Map<String, Object> result) {
          //定位监听回调
          setState(() {
            try {
              // 将原生端返回的定位结果信息存储在定位结果类中
              this.bdMapLocation = BaiduLocation.fromMap(result);
              if (bdMapLocation.errorCode != null) {
                //发生错误
                bdMapLocationError(bdMapLocation.errorCode);
              } else {
                //定位成功
                 bdMapLocationSuccess();
              }
            } catch (e) {
              //发生异常
              bdMapLocationError(e.toString());
            }
          });
        });
        startTimer();
        this.signButtonEvent = onSignButtonClick;
      });
    } catch (e) {
      showToast("定位出错:" + e.toString());
    }
  }

  void startTimer(){
    //开始定位
    if (Platform.isIOS) {
      Future.delayed(Duration(seconds: 2),(){
        reStartLocation();
        this.iosFlushLocationTimer =Timer.periodic(Duration(seconds: 5), (timer) {reStartLocation();});
      });
    } else if (Platform.isAndroid) {
      startLocation();
    }
  }

  //定位失败处理
  bdMapLocationError(code) {
    this.userCurrentLatitude = null;
    this.userCurrentLongitude = null;
    this.signInDistance = null;
    if (code != null) {
      showToast("定位失败:$code");
      //定位异常则延时一秒重启定位
      Future.delayed(Duration(seconds: 1), () {
        reStartLocation();
      });
    }
  }

  //定位成功处理
  bdMapLocationSuccess() {
    this.refreshTime = bdMapLocation.locTime;
    this.userCurrentLatitude = bdMapLocation.latitude;
    this.userCurrentLongitude = bdMapLocation.longitude;
    this.signInDistance = getDistance(userCurrentLatitude, userCurrentLongitude,
        signInLatitude, signInLongitude);
    this._controller.evaluateJavascript("searchBdMapLocation($signInLongitude,$signInLatitude,$userCurrentLongitude,$userCurrentLatitude)");
  }

  //打卡按钮点击
  void onSignButtonClick() {
    setState(() {
      this.signButtonEvent = null;
    });
    if (this.signInDistance == null || this.signInDistance > this.signInScope) {
      AudioPlayerUtil.localPlay("audio/signfail.mp3");
      showToast("不在打卡范围!");
      this.signButtonEvent = onSignButtonClick;
    } else {
      HttpUtil.getInstance(context).post("attendancerecord/saveApp", data: {
        "signLongitude": this.signInLongitude,
        "signLatitude": this.signInLatitude
      }).then((response) {
        try {
          Map data = json.decode(response.data);
          if (data["status"] != null && data["status"]) {
            AudioPlayerUtil.localPlay("audio/signsuccess.mp3");
            showToast("打卡成功", duration: Duration(seconds: 2));
            loadUserSignLocation();
          } else {
            AudioPlayerUtil.localPlay("audio/signfail.mp3");
            showToast("打卡失败!", duration: Duration(seconds: 2));
          }
        } finally {
          setState(() {
            this.signButtonEvent = onSignButtonClick;
          });
        }
      });
    }
  }


  //获取打卡位置数据
  Future<bool> loadUserSignLocation() async {
    await HttpUtil.getInstance(context)
        .get("attendanceshift/getAttendancesById")
        .then((response) {
      Map data = json.decode(response.data);
      setState(() {
        this.signInLatitude = double.parse(data["attendanceshift"]["latitude"]);
        this.signInLongitude =double.parse(data["attendanceshift"]["longitude"]);
        this.signInScope = double.parse(data["attendanceshift"]["scope"]);
        this.signInAddress = data["attendanceshift"]["address"];
        this.signInLocationDetail=data["attendanceshift"]["detailed"];
        HttpUtil.getInstance(context)
            .post("attendanceshift/getAttendancerecordById")
            .then((response1) {
          Map attendanceRecord =json.decode(response1.data)["attendancerecord"];
          this.signShifts = [];
          setState(() {
            for (int i = 1; i <= 2; i++) {
              this.signShifts.add(Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "打卡班次$i",
                        style: TextStyle(
                            color: (attendanceRecord["recordtime$i"] != null
                                ? Colors.green
                                : Colors.grey)),
                      ),
                      Text(data["attendanceshift"]["clocktime$i"]),
                      Container(
                        padding: EdgeInsets.all(3),
                        child: Text(
                            attendanceRecord["recordtime$i"] != null
                                ? "已打卡"
                                : "未打卡",
                            style: TextStyle(
                                color: (attendanceRecord["recordtime$i"] != null
                                    ? Colors.green
                                    : Colors.grey),
                                fontSize: 10)),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: (attendanceRecord["recordtime$i"] != null
                                    ? Colors.green
                                    : Colors.grey)),
                            borderRadius: BorderRadius.circular(5)),
                      )
                    ],
                  )));
            }
          });
        });
      });
    });
    return true;
  }

  //距离计算(根据起始坐标计算距离)
  double getDistance(double lat1, double lng1, double lat2, double lng2) {
    double radLat1 = rad(lat1);
    double radLat2 = rad(lat2);
    double a = radLat1 - radLat2;
    double b = rad(lng1) - rad(lng2);
    double s = 2 *
        asin(sqrt(pow(sin(a / 2), 2) +
            cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
    return s * 6378138.0;
  }

  double rad(double d) {
    return d * pi / 180.0;
  }

  //距离换算(根据距离大小换算成千米或米)
  String distanceConversion() {
    int meterSignInDistance = signInDistance.round();
    if (meterSignInDistance <= 1000) {
      return meterSignInDistance.toString() + " 米";
    } else {
      double kilometerSignInDistance = meterSignInDistance / 1000.0;
      return kilometerSignInDistance.toString() + " 公里";
    }
  }

  /// 设置android端和ios端定位参数
  void _setLocOption() {
    /// android 端设置定位参数
    BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
    androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(false); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(false); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(false); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
    androidOption.setScanspan(5000); // 设置发起定位请求时间间隔
    Map androidMap = androidOption.getMap();
    /// ios 端设置定位参数
    BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
    iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    iosOption.setBMKLocationCoordinateType("BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
    iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
    iosOption.setLocationTimeout(10); // 设置位置获取超时时间
    iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
    iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
    iosOption.setDistanceFilter(100); // 设置定位最小更新距离
    iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
    iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停
    Map iosMap = iosOption.getMap();
    locationPlugin.prepareLoc(androidMap, iosMap);
  }


  /// 重启定位
  void reStartLocation(){
    stopLocation();
    startLocation();
  }

  /// 启动定位
  void startLocation() {
    _setLocOption();
    locationPlugin?.startLocation();
  }

  /// 停止定位
  void stopLocation() {
    locationPlugin?.stopLocation();
  }


  @override
  void initState() {
    super.initState();
    startAMapLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locationListener?.cancel(); // 停止定位
    iosFlushLocationTimer?.cancel();
  }

  @override
  void didUpdateWidget(AttendancePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
