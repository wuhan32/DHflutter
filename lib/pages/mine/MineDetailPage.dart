import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oa/components/FadeRoute.dart';
import 'package:oa/components/PhotoViewSimpleScreen.dart';
import 'package:oa/json/user_info_entity.dart';
import 'package:oa/pages/mine/MineDetailEditPage.dart';
import 'package:oa/utils/AuthUtil.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:http_parser/http_parser.dart';

class MineDetailPage extends StatefulWidget {
  @override
  MineDetailPageState createState() => new MineDetailPageState();
}

class MineDetailPageState extends State<MineDetailPage> {
  //用户信息
  UserInfoEntity userInfo = UserInfoEntity();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text('个人资料'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              //修改资料
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return MineDetailEditPage();
              })).then((_) {
                loadUserInfo();
              });
            },
          )
        ],
      ),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    return Column(
      children: <Widget>[
        buildHeadPic(),
        buildInfoItem(Icons.person, "姓名", this.userInfo.chsname),
        Divider(),
        buildInfoItem(Icons.group, "部门", this.userInfo.orgname),
        Divider(),
        buildInfoItem(Icons.work, "职位", this.userInfo.title),
        Divider(),
        buildInfoItem(Icons.person_add, "领导", this.userInfo.immediateleader),
        Divider(),
        buildInfoItem(Icons.phone, "手机", this.userInfo.mobile),
        Divider(),
        buildInfoItem(Icons.email, "邮箱", this.userInfo.email),
        Divider(),
        buildInfoItem(Icons.account_box, "账号", this.userInfo.ename),
        Divider(),
        buildInfoItem(Icons.confirmation_number, "编号", this.userInfo.userno),
      ],
    );
  }

  Widget buildHeadPic() {
    return Expanded(
        flex: 4,
        child: Container(
          child: Center(
            child: GestureDetector(
              onTap: () {
                //修改头像
                updateUserHeadPic();
              },
              child: Container(
                margin: EdgeInsets.only(top: 30, bottom: 40),
                child: Stack(
                  children: <Widget>[
                    ClipOval(
                      child: CachedNetworkImage(
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        imageUrl: "${this.userInfo.avater}",
                        placeholder: (context, url) =>Container(
                          height: 80,
                          width: 80,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>Container(
                          height: 80,
                          width: 80,
                          alignment: Alignment.center,
                          child: Icon(Icons.person,size: 40,color: Colors.grey,),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.white70
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 20,
                      padding: EdgeInsets.all(1),
                      margin: EdgeInsets.only(top: 59, left: 59),
                      child: Icon(
                        Icons.sync,
                        color: Colors.white,
                        size: 18,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffC0C0C0),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffC0C0C0)),
                    borderRadius: BorderRadius.circular(40)),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Color(0xFFedeeef),
            border:Border.lerp(Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5),width: 0.5)), null,0.3),
          ),
        )
    );
  }

  //修改用户头像
  void updateUserHeadPic() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.photo_camera),
                    Text("拍照"),
                  ],
                ),
                onTap: () async {
                  _cameraImage();
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.photo_library), Text("选择照片")],
                ),
                onTap: () async {
                  _selectedImage();
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.remove_red_eye), Text("查看照片")],
                ),
                onTap: () async {
                  _lookUserHeadPic();
                },
              ),
            ],
          );
        });
  }

  //查看用户头像
  _lookUserHeadPic() {
    Navigator.of(context)
        .push(FadeRoute(
            page: NetWorkPhotoViewSimpleScreen(
      imageUrl: this.userInfo.avater,
      heroTag: 'simple',
    )))
        .then((_) {
      Navigator.pop(context);
    });
  }

  Widget buildInfoItem(IconData iconData, String itemName, String itemValue) {
    return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          height: 25,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(itemName == null ? "" : "$itemName\\",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          )),
                      Icon(
                        iconData,
                        color: Colors.lightBlueAccent,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      itemValue == null ? "" : itemValue,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    )),
              )
            ],
          ),
        ));
  }

  //选择本地图片
  void _selectedImage() async {
    ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        String path = image.path;
        String name = path.substring(path.lastIndexOf("/") + 1, path.length);
        String suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
        FormData formData = FormData.fromMap({
          "file": MultipartFile.fromFileSync(path,
              filename: name, contentType: MediaType.parse("image/$suffix"))
        });
        HttpUtil.getInstance(context)
            .uploadFile("userinfo/updateUserheadPic", data: formData)
            .then((response) {
          Map result = json.decode(response.data);
          if (result["status"] != null && result["status"]) {
            AuthUtil.updateUserHeadPic(result["data"]).then((valeu) {
              showToast("更换成功!");
              loadUserInfo();
            });
          } else {
            showToast("头像上传失败!");
          }
        });
      }
    });
  }

  //拍照
  void _cameraImage() async {
    ImagePicker.pickImage(source: ImageSource.camera).then((image) {
      if (image != null) {
        String path = image.path;
        String name = path.substring(path.lastIndexOf("/") + 1, path.length);
        String suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
        FormData formData = FormData.fromMap({
          "file": MultipartFile.fromFileSync(path,
              filename: name, contentType: MediaType.parse("image/$suffix"))
        });
        HttpUtil.getInstance(context)
            .uploadFile("userinfo/updateUserheadPic", data: formData)
            .then((response) {
          Map result = json.decode(response.data);
          if (result["status"] != null && result["status"]) {
            AuthUtil.updateUserHeadPic(result["data"]).then((valeu) {
              showToast("更换成功!");
              loadUserInfo();
            });
          } else {
            showToast("头像上传失败!");
          }
        });
      }
    });
  }

  void loadUserInfo() async {
    AuthUtil.getUserInfo().then((userInfo) {
      setState(() {
        this.userInfo = userInfo;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(MineDetailPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
