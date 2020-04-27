import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/pages/news/NewsListPage.dart';
import 'package:oa/pages/news/VideoListPage.dart';
import 'package:oa/utils/Constants.dart';

class NewsPage extends StatefulWidget {

  @override
  NewsPageState createState() => new NewsPageState();
}

class NewsPageState extends State<NewsPage> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:Size.fromHeight(80) ,
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
                tabs: [
                  Tab(text: "新闻",icon: Icon(Icons.fiber_new),),
                  Tab(text: "视频",icon: Icon(Icons.video_library))
                ],
              unselectedLabelColor: Colors.grey,
              labelColor:Constants.primaryColor,
              indicatorColor: Constants.primaryColor,
            ),
          ),
        ),
        body: TabBarView(children: <Widget>[
          NewsListPage(),
          VideoListPage()
        ]),
      ),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(NewsPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
