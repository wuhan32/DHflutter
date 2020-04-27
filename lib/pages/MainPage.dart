import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oa/components/AlertWidget.dart';
import 'package:oa/dao/ImMessage.dart';
import 'package:oa/json/user_info_entity.dart';
import 'package:oa/modle/TabItem.dart';
import 'package:oa/pages/attendance/AttendancePage.dart';
import 'package:oa/pages/mine/MineDetailPage.dart';
import 'package:oa/pages/mine/QrCodeBusinessCardPage.dart';
import 'package:oa/pages/tabPage/ContractsPage.dart';
import 'package:oa/pages/tabPage/HomePage.dart';
import 'package:oa/pages/tabPage/MessagePage.dart';
import 'package:oa/pages/tabPage/NewsPage.dart';
import 'package:oa/utils/AudioPlayerUtil.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oa/utils/Constants.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oa/utils/ImWebsocketUtil.dart';


class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> with WidgetsBindingObserver {
  static Function mainMessageTip;

  //底部导航栏路由配置
  List<TabItem> tebItems=[
    TabItem(
        bottomBarTitle: "首页",
        icon: Icon(Icons.apps),
        appBarTitle: "大恒信息化系统",
        route: HomePage()),
    TabItem(
        bottomBarTitle: "通讯录",
        icon: Icon(Icons.contacts),
        appBarTitle: "集团通讯录",
        route: ContactsPage()),
    TabItem(
        bottomBarTitle: "消息",
        icon: Stack(
          children: <Widget>[
            Icon(Icons.message),
            Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 10,
                  width: 10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red.withOpacity(0.0)),
                ))
          ],
        ),
        appBarTitle: "消息",
        route: MessagePage()),
    TabItem(
        bottomBarTitle: "资讯",
        icon: Icon(Icons.description),
        appBarTitle: "大恒资讯",
        route: NewsPage())
  ];
  //用户信息
  UserInfoEntity userInfo = UserInfoEntity();
  //底部导航栏当前选中索引
  int curSelect = 0;
  //水平滑动起始点
  double horizontalDragStart;
  //水平滑动结束点
  double horizontalDragEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        horizontalDragStart = details.localPosition.dx;
        horizontalDragEnd = details.localPosition.dx;
      },
      onHorizontalDragUpdate: (details) {
        horizontalDragEnd += details.delta.dx;
      },
      onHorizontalDragEnd: (details) {
        if ((horizontalDragEnd - horizontalDragStart) > 0.0 && curSelect > 0) {
          setState(() {
            curSelect--;
          });
        } else if ((horizontalDragEnd - horizontalDragStart) < 0.0 &&
            curSelect < tebItems.length - 1) {
          setState(() {
            curSelect++;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Center(
            child: Text(tebItems.isEmpty?"首页":tebItems[curSelect].appBarTitle),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                //打卡功能逻辑
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AttendancePage();
                }));
              },
              child: Container(
                width: 60,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.my_location),
                      Text(
                        "考勤",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: buildBottomNavigationBarItems(),
          currentIndex: this.curSelect,
          selectedItemColor: Colors.white,
          unselectedItemColor: Color(0xffC0C0C0),
          onTap: (index) {
            if (this.curSelect != index) {
              setState(() {
                this.curSelect = index;
              });
            }
          },
        ),
        body: tebItems[curSelect].route,
        drawer: Drawer(
          elevation: 5,
          child: Container(
            color: Colors.white70,
            child: buildDrawerItems(),
          ),
        ),
      ),
    );
  }

  //构建侧滑抽屉栏
  ListView buildDrawerItems() {
    List<Widget> viewItems = [];
    viewItems.add(buildPersonalInformation(
        userName: this.userInfo.chsname,
        email: this.userInfo.email,
        headPic: this.userInfo.avater));
    viewItems.add(ListTile(
      leading: Icon(Icons.my_location),
      title: Text("签到"),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AttendancePage();
        }));
      },
    ));
    viewItems.add(Divider());
    viewItems.add(ListTile(
      leading: Icon(Icons.person),
      title: Text("个人信息"),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MineDetailPage();
        })).then((_) {
          loadUserInfo();
        });
      },
    ));
    viewItems.add(Divider());
    viewItems.add(ListTile(
      leading:  FaIcon(FontAwesomeIcons.qrcode,color: Colors.grey),
      title: Text("二维码名片"),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return QrCodeBusinessCardPage(userInfo: userInfo,);
        }));
      },
    ));
    viewItems.add(Divider());
    viewItems.add(ListTile(
      leading: Icon(Icons.computer),
      title: Text("个人日志"),
      onTap: () {},
    ));
    viewItems.add(Divider());
    viewItems.add(ListTile(
      leading: Icon(Icons.delete_sweep),
      title: Text("清理聊天记录"),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertWidget(
                title: '清空记录',
                message: '确定清除全部聊天记录吗？',
                confirmCallback: () {
                  ImWebSocketUtil.imMessageDao.deleteAllMessageRecord().then((num) {
                    MainPageState.mainMessageTip(false);
                    if(MessagePageState.reBuildMessagePage!=null){
                      MessagePageState.reBuildMessagePage();
                    }
                    EasyLoading.showInfo("清理了 $num 条记录");
                  });
                }));
      },
    ));
    viewItems.add(Divider());
    viewItems.add(ListTile(
      leading: Icon(Icons.refresh),
      title: Text("软件更新"),
      onTap: () {},
    ));
    viewItems.add(Divider());
    viewItems.add(ListTile(
      leading: Icon(Icons.cancel),
      title: Text("注销登录"),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertWidget(
                title: '温馨提示',
                message: '你确定要退出登录吗？',
                confirmCallback: () {
                  AuthUtil.logout(context);
                }));
      },
    ));
    viewItems.add(Divider());
    return ListView(
      children: viewItems,
    );
  }

  //构建个人信息卡片
  Widget buildPersonalInformation(
      {String userName, String email, String headPic}) {
    return UserAccountsDrawerHeader(
      accountName: Text(
        userName == null ? "" : userName,
        style: TextStyle(color: Colors.black),
      ),
      accountEmail: Text(
        email == null ? "" : email,
        style: TextStyle(color: Colors.black),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(5), bottom: Radius.circular(5))),
      currentAccountPicture: ClipOval(
        child: CachedNetworkImage(
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          imageUrl: headPic == null ? "" : headPic,
          placeholder: (context, url) => Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            child: Icon(Icons.person,size: 40,color: Colors.grey,),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(50),
                color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  //构建底部导航栏
  List<BottomNavigationBarItem> buildBottomNavigationBarItems() {
    List<BottomNavigationBarItem> bottomNavigationBarItems = [];
    for (int i = 0; i < tebItems.length; i++) {
      bottomNavigationBarItems.add(BottomNavigationBarItem(
          icon: tebItems[i].icon,
          title: Text(tebItems[i].bottomBarTitle),
          backgroundColor: Constants.primaryColor));
    }
    return bottomNavigationBarItems;
  }

  void loadUserInfo() async {
    AuthUtil.getUserInfo().then((userInfo) {
      setState(() {
        this.userInfo = userInfo;
      });
    });
  }


  //拉取离线消息
  loadOffLineMessage() async {
    Response response = await HttpUtil.getInstance(context)
        .get("instantMessage/loadOffLineMessage");
    Map result = json.decode(response.data);
    if (result["status"]) {
      List messages = result["data"];
      List<int> idList = List<int>();
      for (int i = 0; i < messages.length; i++) {
        try {
          ImMessage imMessage = ImMessage.fromMap(messages[i]);
          int messageId = imMessage.id;
          imMessage.id = null;
          //离线消息提示
          AudioPlayerUtil.localPlay("audio/message.mp3");
          //加入本地库
          ImWebSocketUtil.imMessageDao.insert(imMessage);
          idList.add(messageId);
        } catch (e) {
          print(e);
        }
      }
      if (idList.isNotEmpty) {
        //消息拉取完毕,删除服务器暂存消息
        HttpUtil.getInstance(context).get("instantMessage/deleteInstantMessage",
            data: {"ids": idList.join(",")});
      }
    } else {
      print("离线消息拉取失败");
    }
  }



  //加载未读总数
  void loadReadTotal(){
    ImWebSocketUtil.imMessageDao.loadNotReadTotal().then((int notReadTotal){
      if(notReadTotal>0){
        MainPageState.mainMessageTip(true);
      }else{
        MainPageState.mainMessageTip(false);
      }
    });
  }



  //设置tab栏
  setTabItems(bool flag){
    setState(() {
      tebItems[2] = TabItem(
          bottomBarTitle: "消息",
          icon: Stack(
            children: <Widget>[
              Icon(Icons.message),
              Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 10,
                    width: 10,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red.withOpacity(flag?1.0:0.0)),
                  ))
            ],
          ),
          appBarTitle: "消息",
          route: MessagePage()
      );
    });
  }


  @override
  void initState() {
    //消息tab提示函数
    mainMessageTip=setTabItems;
    //加载用户信息
    loadUserInfo();
    //开启WebSocket
    ImWebSocketUtil.openImServer().then((_){
      //拉取离线消息
      loadOffLineMessage().then((_){
        //加载未读消息总数
        loadReadTotal();
      });
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didUpdateWidget(MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        print("失活");
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        print("恢复");
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        print("暂停");
        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        print("离开");
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
