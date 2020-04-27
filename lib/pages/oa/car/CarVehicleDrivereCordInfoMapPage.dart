import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CarVehicleDrivereCordInfoMapPage extends StatefulWidget {
  @override
  _CarVehicleDrivereCordInfoMapPageState createState() => _CarVehicleDrivereCordInfoMapPageState();
}

class _CarVehicleDrivereCordInfoMapPageState extends State<CarVehicleDrivereCordInfoMapPage> {
  WebViewController _controller;
  String _title = "webview";
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("轨迹"),
      ),
      child: SafeArea(
        child: WebView(
          initialUrl: "http://www.dahengzh.com/app/carVehicleDrivereCordInfoMap.html",
          javascriptMode: JavascriptMode.unrestricted, onWebViewCreated: (controller) {
          _controller = controller;
        },

        ),
      ),
    );
  }
}