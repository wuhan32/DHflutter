import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


//网络图片查看器
class NetWorkPhotoViewSimpleScreen extends StatelessWidget{

  final String imageUrl;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String heroTag;

  const NetWorkPhotoViewSimpleScreen({
    this.imageUrl,//图片
    this.loadingChild,//加载时的widget
    this.backgroundDecoration,//背景修饰
    this.minScale,//最大缩放倍数
    this.maxScale,//最小缩放倍数
    this.heroTag,//hero动画tagid
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        onLongPress: (){
          ///保存图片

        },
        child: Container(
          color: Colors.white70,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  loadingBuilder: loadingChild==null?null:(context,event)=>loadingChild,
                  backgroundDecoration: backgroundDecoration,
                  minScale: minScale,
                  maxScale: maxScale,
                  heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
                  enableRotation: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}