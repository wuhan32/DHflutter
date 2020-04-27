import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:oa/modle/FuncItem.dart';

import '../../utils/HttpUtil.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  List funcItems = [
    FuncItem(title: "行政办公", icon: Icon(Icons.work, size: 15), route: "OaListPage"),
    FuncItem(title: "餐饮系统",icon: Icon(Icons.restaurant_menu, size: 15),route: null),
    FuncItem(title: "采集系统", icon: Icon(Icons.screen_share, size: 15), route: null),
    FuncItem(title: "物资仓储",icon: Icon(Icons.account_balance, size: 15),route: null),
    FuncItem(title: "金融机构",icon: Icon(Icons.account_balance, size: 15),route: null),
    FuncItem(title: "项目管理", icon: Icon(Icons.view_agenda, size: 15), route: "ProjectListPage"),
    FuncItem(title: "智慧工地", icon: Icon(Icons.dvr, size: 15), route: null),
    FuncItem(title: "合同管理", icon: Icon(Icons.nature, size: 15), route: null),
    FuncItem(title: "教育机构", icon: Icon(Icons.school, size: 15), route: null),
    FuncItem(title: "个人事务",icon: Icon(Icons.lightbulb_outline, size: 15),route: null),
    FuncItem(title: "个人日程",icon: Icon(Icons.assignment_turned_in, size: 15),route: null),
    FuncItem(title: "事务申请", icon: Icon(Icons.assignment, size: 15), route: "ProcessList"),
  ];
 //轮播图
 List<String> bannerImages = [];
  //功能区颜色奇数位颜色
  Color colorOdd = Color(0xFFE0E0E0);
  //功能区颜色偶数位颜色
  Color colorEven = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildBanner(),
        buildFuncArea(),
      ],
    );
  }

  //构建轮播图
  Widget buildBanner() {
    List<Widget> children = [];
    if(bannerImages.length>0){
      for (int i = 0; i < bannerImages.length; i++) {
        children.add(CachedNetworkImage(
          imageUrl: bannerImages[i],
          placeholder: (context, url) => Center(
            child: Container(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.fill,
        ));
      }
    }else{
        children.add(CachedNetworkImage(
          imageUrl: "",
          placeholder: (context, url) => Center(
            child: Container(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.fill,
        ));
    }
    return AspectRatio(
      aspectRatio: 1.5,
      child: Swiper.children(
        autoplay: true,
        children: children,
      ),
    );
  }

  //构建功能区
  Widget buildFuncArea() {
    List<Widget> items = List();
    for (int i = 1; i <= funcItems.length; i++) {
      items.add(GestureDetector(
        onTap: () {
          if (funcItems[i - 1].route == null) {
            showNotDevelop();
          } else {
            Navigator.pushNamed(context, funcItems[i - 1].route);
          }
        },
        child: Container(
            color: i.isOdd ? colorOdd : colorEven,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                funcItems[i - 1].icon,
                Text(funcItems[i - 1].title, style: TextStyle(fontSize: 12))
              ],
            )),
      ));
    }
    return Expanded(
          child: GridView.count(
              crossAxisCount: 3, childAspectRatio: 2, children: items)
      );
  }

  //显示未开发功能提示
  void showNotDevelop() {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Container(
        height: 20,
        alignment: Alignment.center,
        child: Text("暂未开发"),
      ),
      duration: Duration(milliseconds: 200),
    ));
  }


  loadBannerImages()async{
    HttpUtil.getInstance(context).get("vanityproject/getImgurls").then((response){
      List result=json.decode(response.data);
      this.bannerImages.clear();
      for(int i=0;i < result.length;i++){
        this.bannerImages.add(result[i]["imgUrl"]!=null&&result[i]["imgUrl"].toString().trim()!=""?HttpUtil.httpBaseUrl+result[i]["imgUrl"].toString():"");
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBannerImages();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
