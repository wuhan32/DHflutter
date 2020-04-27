import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oa/modle/VideoItem.dart';
import 'package:video_player/video_player.dart';



//视频详情
class VideoDetailPage extends StatefulWidget {

  final VideoItem resource;

  VideoDetailPage(this.resource):super();

  @override
  VideoDetailPageState createState() => new VideoDetailPageState();

}

class VideoDetailPageState extends State<VideoDetailPage> {

  VideoPlayerController videoController;
  ChewieController cheWieController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resource.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.white70,
            child: buildMedia(),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Html(
              data: widget.resource.content,
              defaultTextStyle: TextStyle(
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      )
    );
  }
  
  Widget buildMedia(){
    if(widget.resource.resourceType=="video"){
      return AspectRatio(
        aspectRatio: cheWieController.aspectRatio,
        child: SingleChildScrollView(
          child: Chewie(
            controller: cheWieController,
          ),
        ),
      );
    }else if(widget.resource.resourceType=="picture"){
      return AspectRatio(
        aspectRatio: 2,
        child: CachedNetworkImage(
          imageUrl:widget.resource.resourceUrl,
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
    }else{
      return AspectRatio(
        aspectRatio: 2,
        child:  Center(
          child: Text("资源类型不支持"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.resource.resourceType=="video"){
      this.videoController = VideoPlayerController.network(
          widget.resource.resourceUrl,
      );
      this.cheWieController =ChewieController(
        aspectRatio: 1.8,
        videoPlayerController: videoController,
        autoPlay: true,
        looping: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
          handleColor: Colors.blue,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white70,
        ),
        autoInitialize: true,
      );
    }
  }

  @override
  void dispose() {
    if(widget.resource.resourceType=="video") {
      videoController.dispose();
      cheWieController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(VideoDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}

