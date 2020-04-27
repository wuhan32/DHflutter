import 'package:flutter/cupertino.dart';

class TabItem {
  //底部item标题
  String bottomBarTitle;
  //底部item图标
  Widget icon;
  //顶部标题
  String appBarTitle;
  //tab路由
  Widget route;

  TabItem({this.bottomBarTitle, this.icon, this.appBarTitle, this.route})
      : super();
}
