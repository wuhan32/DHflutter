import 'package:flutter/material.dart';
import 'package:oa/json/user_info_entity.dart';
import 'package:qr_flutter/qr_flutter.dart';



class QrCodeBusinessCardPage extends StatefulWidget {

  final UserInfoEntity userInfo;
  QrCodeBusinessCardPage({Key key,this.userInfo}):super(key:key);


  @override
  QrCodeBusinessCardPageState createState() => new QrCodeBusinessCardPageState();
}

class QrCodeBusinessCardPageState extends State<QrCodeBusinessCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('二维码名片'),
        centerTitle: true,
      ),
      body: Center(
        child: QrImage(
          data: 'http://www.dahengzh.com/app/qrCodeBusinessCard.html?userId=${widget.userInfo.id}',
          version: QrVersions.auto,
          size: 320,
          gapless: false,
          embeddedImage: NetworkImage(widget.userInfo.avater),
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: Size(60, 60),
          ),
          embeddedImageEmitsError: true,
        ),
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
  void didUpdateWidget(QrCodeBusinessCardPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}