import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oa/modle/VideoItem.dart';
import 'package:oa/pages/news/VideoDetailPage.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';




class VideoListPage extends StatefulWidget {
  @override
  VideoListPageState createState() => new VideoListPageState();
}

class VideoListPageState extends State<VideoListPage> {



  //视频资源列表
  List<VideoItem> videoItems=[];

 Map<String,String> videoTypes={};

 Map<String,String> resourceTypes={
   "video":"视频",
   "picture":"图片"
 };


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: buildContent(),
    );
  }


  Widget buildContent(){
    List<Widget> videoItemList=[];
    for(int i=0;i<videoItems.length;i++){
      videoItemList.add(
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
              return VideoDetailPage(videoItems[i]);
            })).then((_){
              loadVideoType();
              loadVideoList();
            });
          },
          child: Card(
            color: Colors.white70,
            child:Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:5,bottom: 5,right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Text(videoTypes[videoItems[i].type]==null?"":videoTypes[videoItems[i].type],style: TextStyle(fontSize: 10,color: Colors.blue),),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Text(resourceTypes[videoItems[i].resourceType]==null?"":resourceTypes[videoItems[i].resourceType],style: TextStyle(fontSize: 10,color: Colors.orange),),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(8)
                        ),
                      )
                    ],
                  ),
                ),
                CachedNetworkImage(
                  imageUrl: videoItems[i].fetchPic==null?"":videoItems[i].fetchPic,
                  placeholder: (context, url) => Center(
                    child: Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fill,
                ),
                Text(videoItems[i].title,style: TextStyle(),textAlign: TextAlign.center,),
              ],
            ),
          ),
        )
          );
    }
    return GridView.count(
        padding: EdgeInsets.all(10),
        crossAxisCount: 2,
        children: videoItemList,
    );
  }



  //加载视频资源类型
  loadVideoType()async{
    Response response=await HttpUtil.getInstance(context).get(
        "appContract/listsystems",
        data: {
          "type":"business",
          "code":"cp1578014935242"
        });
    Map result=json.decode(response.data);
    if(result["total"]!=null&&result["total"]>0){
      setState(() {
        this.videoItems.clear();
        for(int i=0;i<result["rows"].length;i++){
            videoTypes[result["rows"][i]["id"]]=result["rows"][i]["name"];
        }
      });
    }
  }

  loadVideoList()async{
    Response response=await HttpUtil.getInstance(context).get("portalResource/loadByType");
    Map result=json.decode(response.data);
    if(result["status"]){
      if(result["data"].length>0){
        setState(() {
          this.videoItems.clear();
          for(int i=0;i<result["data"].length;i++){
            this.videoItems.add(
                VideoItem(
                title: result["data"][i]["title"],
                content: result["data"][i]["content"],
                type: result["data"][i]["type"],
                fetchPic: result["data"][i]["resource"]["fetch_pic"],
                resourceUrl: result["data"][i]["resource"]["resource_url"],
                resourceType: result["data"][i]["resource"]["type"]
              )
            );
          }
        });
      }
    }else{
      showToast(result["msg"]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadVideoType();
    loadVideoList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(VideoListPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}