import 'package:flutter/material.dart';

//自定义确认对话框
class AlertWidget extends Dialog {
  final String title;
  final String message;
  final VoidCallback confirmCallback;
  final VoidCallback cancelCallback;

  AlertWidget(
      {this.title, this.message, this.cancelCallback, this.confirmCallback});
  @override
  Widget build(BuildContext context) {
    return Material(
//        type: MaterialType.transparency,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(left: 40, right: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 16,
              ),
              Text(message),
              SizedBox(
                height: 20,
              ),
              Divider(
                height: 1,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: FlatButton(
                            child: Text('取消'),
                            onPressed: cancelCallback == null
                                ? () {
                                    Navigator.pop(context);
                                  }
                                : cancelCallback,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1, color: Color(0xffEFEFF4))),
                          ),
                        )),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        child: Text(
                          '确定',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          confirmCallback();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
