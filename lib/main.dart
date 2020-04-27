import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oa/pages/login/AccountPasswLoginPage.dart';
import 'package:oa/pages/oa/car/CarVehicleFeeListPage.dart';
import 'package:oa/pages/oa/civilService/purchaseApply/PurchaseApplyListPage.dart';
import 'package:oa/pages/oa/civilService/suppliesApply/SuppliesApplyListPage.dart';
import 'package:oa/pages/oa/civilService/trainingPlan/TrainingPlanListPage.dart';
import 'package:oa/pages/process/examineProcess/ProcessListPage.dart';
import 'package:oa/pages/attendance/SignRecord.dart';
import 'package:oa/pages/MainPage.dart';
import 'package:oa/pages/oa/civilService/daily/DailyRecord.dart';
import 'package:oa/pages/project/paymentContract/PaymentContractList.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oa/utils/Constants.dart';
import 'package:oktoast/oktoast.dart';
import 'pages/oa/OaListPage.dart';
import 'pages/oa/car/CarListPage.dart';
import 'pages/oa/car/CarVehicleAssignrecordListPage.dart';
import 'pages/oa/car/CarVehicleDisposalListPage.dart';
import 'pages/oa/car/CarVehicleDrivereCordListPage.dart';
import 'pages/oa/car/CarVehiclereMinderListPage.dart';
import 'pages/project/ProjectListPage.dart';
import 'pages/project/ProjectManagement/ProjectDeclaration.dart';
import 'pages/project/IncomeContract/IncomeContractList.dart';
import 'pages/project/ProceedsContract/ProceedsContractList.dart';
import 'pages/project/ScheduleProject/ScheduleProjectList.dart';
import 'pages/project/Completion/CompletionList.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //加载动画样式
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)//显示时间
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle //动画样式
    ..loadingStyle = EasyLoadingStyle.custom //动画类型
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Constants.primaryColor //进度条颜色
    ..backgroundColor = Colors.white//背景颜色
    ..indicatorColor = Colors.black//动画颜色
    ..textColor = Colors.black//文本颜色
    ..maskColor = Constants.primaryColor.withOpacity(0)
    ..userInteractions = true;
  runApp(MyApp(loginState: (await checkLoginState())));
}

class MyApp extends StatelessWidget {
  //登录状态
  final bool loginState;

  MyApp({Key key, this.loginState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
      child: OKToast(
          position: ToastPosition.center,
          textPadding: EdgeInsets.all(20),
          duration: Duration(milliseconds: 1500),
          child: MaterialApp(
            title: '大恒建设OA',
            theme: ThemeData(
              primarySwatch: Constants.primaryColor,
            ),
            home: WillPopScope(
              child: loginState ? MainPage() : AccountPasswordLoginPage(),
              onWillPop: ()async {
                //禁止返回按钮退出app
                //SystemNavigator.pop(animated: true);
                //exit(0);
                return false;
              },
            ),
            routes: {
              "OaListPage":(BuildContext context)=>OaListPage(),//行政办公模块
              "SignRecordPage":(BuildContext context)=>SignRecordPage(),//考勤记录查询
              "CarListPage":(BuildContext context)=>CarListPage(),//车辆管理
              "CarVehicleAssignrecordListPage":(BuildContext context)=>CarVehicleAssignrecordListPage(),//车辆管理-车辆分派列表
              "CarVehicleDrivereCordListPage":(BuildContext context)=>CarVehicleDrivereCordListPage(),//车辆管理-车辆行驶记录列表
              "CarVehiclereMinderListPage":(BuildContext context)=>CarVehiclereMinderListPage(),//车辆管理-车辆预警列表
              "CarVehicleDisposalListPage":(BuildContext context)=>CarVehicleDisposalListPage(),//车辆管理-车辆处置列表
              "CarVehicleFeeListPage":(BuildContext context)=>CarVehicleFeeListPage(),//车辆管理-车辆费用列表
              "ProcessList":(BuildContext context) => ProcessList(),//流程列表
              "CarVehicleFeeListPage":(BuildContext context)=>CarVehicleFeeListPage(),//车辆管理-车辆费用列表
              "CarVehicleFeeListPage":(BuildContext context)=>CarVehicleFeeListPage(),//车辆管理-车辆费用列表
              "DailyRecordPage":(BuildContext context)=>DailyRecordPage(),//行政事务-领导日程列表
              "PurchaseApplyListPage":(BuildContext context)=>PurchaseApplyListPage(),//行政事务-办公用品申购列表
              "SuppliesApplyListPage":(BuildContext context)=>SuppliesApplyListPage(),//行政事务-办公用品申领列表
              "TrainingPlanListPage":(BuildContext context)=>TrainingPlanListPage(),//行政事务-培训安排
              "ProjectListPage":(BuildContext context)=>ProjectListPage(),//项目管理
              "ProjectDeclaration":(BuildContext context)=>ProjectDeclaration(),//项目列表
              "IncomeContractList":(BuildContext context)=>IncomeContractList(),//收入合同
              "ProceedsContractList":(BuildContext context)=>ProceedsContractList(),//合同收款
              "PaymentContractList":(BuildContext context)=>PaymentContractList(),//合同付款
              "ScheduleProjectList":(BuildContext context)=>ScheduleProjectList(),//进度款申报
              "CompletionList":(BuildContext context)=>CompletionList(),//完工结算
            },
            localizationsDelegates: [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              const FallbackCupertinoLocalisationsDelegate()
            ],
            supportedLocales: [
              const Locale('en'),
              const Locale('zh'),
              const Locale('ja'),
              const Locale('uk'),
              const Locale('it'),
              const Locale('ru'),
              const Locale('fr'),
            ],
            locale: const Locale('zh'),
          )),
    );
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}


//登录身份校验
Future<bool> checkLoginState() async {
  String token = await AuthUtil.getToken();
  if (token == null || token.trim() == "") {
    return false;
  } else {
    return true;
  }
}
