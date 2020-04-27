

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:flutter_html/flutter_html.dart';

class NewsDetailPage extends StatefulWidget {

  final String newsId;

  NewsDetailPage(this.newsId):super();

  @override
  NewsDetailPageState createState() => new NewsDetailPageState();

}

class NewsDetailPageState extends State<NewsDetailPage> {

  String newsContent="";
  String newsTitle="";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newsTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Html(
          data: newsContent,
          defaultTextStyle: TextStyle(
            letterSpacing: 0,
            height: 2
          ),
        ),
      ),
    );
  }

  loadNewsDetail()async{
      Response response=await HttpUtil.getInstance(context).get("infoissue/formLoad",data: {
        "id":widget.newsId
      });
      Map result=json.decode(response.data);
      setState(() {
        this.newsContent=result["infocontent"];
        this.newsTitle=result["title"];
      });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNewsDetail();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(NewsDetailPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}