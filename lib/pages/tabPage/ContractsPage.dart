import 'dart:convert';
import 'dart:io';

import 'package:azlistview/azlistview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:oa/generated/json/user_info_entity_helper.dart';
import 'package:oa/json/user_info_entity.dart';
import 'package:oa/modle/PersonBean.dart';
import 'package:oa/pages/contacts/ContactsDetail.dart';
import 'package:oa/utils/HttpUtil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatefulWidget {

  @override
  ContactsPageState createState() {
    return ContactsPageState();
  }
}

class ContactsPageState extends State<ContactsPage> {
  int _suspensionHeight = 40;
  int _itemHeight = 65;
  String _suspensionTag = "";
  List<PersonBean> personList = [];

  @override
  void initState() {
    super.initState();
    loadContracts().then((result) {
      if (result != null) {
         result["rows"].forEach((jsonMap){
           UserInfoEntity userInfoEntity = userInfoEntityFromJson(UserInfoEntity(),json.decode(json.encode(jsonMap)));
           personList.add(PersonBean(
               id: userInfoEntity.id,
               name: userInfoEntity.chsname,
               phone: userInfoEntity.mobile,
               headPic: userInfoEntity.avater));
        });
        setState(() {
          if (personList.length>0) {
            _handleList(personList);
            //设置当前索引
            _suspensionTag = personList[0].getSuspensionTag();
          }
        });
      }
    });
  }

  //添加人名索引并排序
  void _handleList(List<PersonBean> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinYin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    SuspensionUtil.sortListBySuspensionTag(list);
  }

  //监听索引tab改变
  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  //构建列表 item Widget.
  Widget _buildListItem(PersonBean person) {
    return Column(
      children: <Widget>[
        Offstage(
          offstage: !(person.isShowSuspension == true),
          child: _buildSusWidget(person.getSuspensionTag()),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: Container(
            margin: EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
                color: Color(0xFFedeeef),
                borderRadius: BorderRadius.circular(5)),
            child: ListTile(
              leading: ClipOval(
                child: CachedNetworkImage(
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                  imageUrl: person.headPic,
                  placeholder: (context, url) => Container(
                    height: 35,
                    width: 35,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 35,
                    width: 35,
                    alignment: Alignment.center,
                    child: Icon(Icons.person),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17.5),
                        color: Colors.white70
                    ),
                  ),
                ),
              ),
              title: Text(person.name),
              subtitle: Text(person.phone),
              trailing: IconButton(
                  icon: Icon(Icons.call),
                  onPressed: () {
                    //拨打电话
                    if(person.phone!=null&&person.phone.trim()!=""){
                      launch("tel:" + person.phone);
                    }else{
                      showToast("电话号码不能为空");
                    }
                  }),
              onTap: () {
                //查询详情
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return ContactsDetailPage(contractUserId: person.id);
                }));
              },
            ),
          ),
        ),
      ],
    );
  }

  ///构建悬停Widget.
  Widget _buildSusWidget(String susTag) {
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        susTag,
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  //查询联系人
  Future<Map> loadContracts() async {
    Response result = await HttpUtil.getInstance(context).get("userinfo/listLoadContacts");
    return result == null ? null : json.decode(result.data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: new AzListView(
              data: personList,
              itemBuilder: (context, model) => _buildListItem(model),
              suspensionWidget: _buildSusWidget(_suspensionTag),
              isUseRealIndex: true,
              itemHeight: _itemHeight,
              suspensionHeight: _suspensionHeight,
              onSusTagChanged: _onSusTagChanged,
            ))
      ],
    );
  }
}
