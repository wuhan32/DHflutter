import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/modle/NewsItem.dart';
import 'package:oa/pages/news/NewsDetailPage.dart';
import 'package:oa/utils/DateTimeUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';





class NewsListPage extends StatefulWidget {
  @override
  NewsListPageState createState() => new NewsListPageState();
}

class NewsListPageState extends State<NewsListPage> {

  //新闻列表
  List<NewsItem> newsList = [];
  //宣传图
  String mainPropagandaPicture="";

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }


  //构建内容
  Widget buildContent(){
    List<Widget> contentItems=[];
    contentItems.add(buildBanner());
    contentItems.addAll(buildNewsItems());
    return ListView(children: contentItems);
  }



  //构建宣传图
  Widget buildBanner(){
    return AspectRatio(
      aspectRatio: 2,
      child: CachedNetworkImage(
        imageUrl:"$mainPropagandaPicture",
        placeholder: (context, url) => Center(
          child: Container(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(),
          ),
        ),
        fit: BoxFit.fill,
      ),
    );
  }

  //构建新闻列表
  List<Widget> buildNewsItems(){
    List<Widget> newsListWidget=[];
    if(newsList.length>0){
      for(int i=0;i < newsList.length;i++){
        newsListWidget.add(Card(
          color: Color(0xfff5f6f7),
          margin: EdgeInsets.only(top: 1),
          child: Container(
            padding: EdgeInsets.only(top: 0, bottom: 0, left:10, right: 5),
            child: ListTile(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return NewsDetailPage(newsList[i].newsId);
                })).then((_){
                  loadNewsList();
                  loadMainPropagandaPicture();
                });
              },
              contentPadding: EdgeInsets.all(0),
              title: Text(
                newsList[i].title.trim(),
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Container(
                  margin: EdgeInsets.only(bottom: 0),
                  padding: EdgeInsets.all(0),
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          newsList[i].subTitle,
                          style: TextStyle(fontSize: 12),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 3, right: 3),
                          child: Text("#${newsList[i].type}#",style: TextStyle(fontSize: 10, color: Colors.blue)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color:Colors.blue)),
                        )
                      ],
                    ),
                  )),
              trailing: newsList[i].coverPic==null||newsList[i].coverPic.trim()==""?null:Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(top: 2),
                child: CachedNetworkImage(
                  imageUrl:"${HttpUtil.httpBaseUrl+newsList[i].coverPic}",
                  placeholder: (context, url) => CircularProgressIndicator(),
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) => Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    child: Text("404",style: TextStyle(color: Colors.white70),),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
      }
    }
    return newsListWidget;
  }


  //加载宣传图
  loadMainPropagandaPicture()async{
    Response response = await HttpUtil.getInstance(context).get("propagandaPicture/mainPropagandaPicture");
    Map result=json.decode(response.data);
    if(result["status"]){
      setState(() {
        this.mainPropagandaPicture = result["data"];
      });
    }else{
      showToast("宣传图加载失败!");
    }
  }

  //加载新闻列表
  loadNewsList() async{
   Response response= await HttpUtil.getInstance(context).get("infoissue/listLoad");
   Map result=json.decode(response.data);
   if(result["total"]>0){
     this.newsList.clear();
     List rows=result["rows"];
     for(int i=0;i<rows.length;i++){
       this.newsList.add(
           NewsItem(
               newsId: rows[i]["id"].toString(),
               title: rows[i]["title"]==null?"大恒新闻":rows[i]["title"],
               type: rows[i]["sysinfotype"]==null?"大恒新闻":rows[i]["sysinfotype"],
               subTitle: rows[i]["issuer"].toString() +"   "+ DateTimeUtil.formatDateString(rows[i]["issuerdate"]),
               coverPic: rows[i]["imgUrl"]
           )
       );
     }
     setState(() {});
   }
  }




  @override
  void initState() {
    // TODO: implement initState
    loadNewsList();
    loadMainPropagandaPicture();
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(NewsListPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}