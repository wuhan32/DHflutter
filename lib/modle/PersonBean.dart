import 'package:azlistview/azlistview.dart' show ISuspensionBean;

//联系人实体
class PersonBean extends ISuspensionBean {
  String id;
  String name;
  String headPic;
  String phone;
  String namePinYin;
  String tagIndex;

  PersonBean(
      {this.id,
      this.name,
      this.headPic,
      this.phone,
      this.namePinYin,
      this.tagIndex})
      : super();

  @override
  String getSuspensionTag() {
    return this.tagIndex;
  }

  @override
  String toString() => "PersonBean {" + " \"name\":\"" + name + "\"" + '}';
}
