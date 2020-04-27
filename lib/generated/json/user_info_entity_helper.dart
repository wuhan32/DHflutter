import 'package:oa/json/user_info_entity.dart';

userInfoEntityFromJson(UserInfoEntity data, Map<String, dynamic> json) {
	if (json['orderno'] != null) {
		data.orderno = json['orderno']?.toInt();
	}
	if (json['roleid'] != null) {
		data.roleid = json['roleid']?.toString();
	}
	if (json['remark'] != null) {
		data.remark = json['remark']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['type'] != null) {
		data.type = json['type']?.toString();
	}
	if (json['orgname'] != null) {
		data.orgname = json['orgname']?.toString();
	}
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['email'] != null) {
		data.email = json['email']?.toString();
	}
	if (json['ownerprojectid'] != null) {
		data.ownerprojectid = json['ownerprojectid']?.toString();
	}
	if (json['rolename'] != null) {
		data.rolename = json['rolename']?.toString();
	}
	if (json['avater'] != null) {
		data.avater = json['avater']?.toString();
	}
	if (json['directleader'] != null) {
		data.directleader = json['directleader']?.toString();
	}
	if (json['sex'] != null) {
		data.sex = json['sex']?.toInt();
	}
	if (json['userno'] != null) {
		data.userno = json['userno']?.toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile']?.toString();
	}
	if (json['immediateleader'] != null) {
		data.immediateleader = json['immediateleader']?.toString();
	}
	if (json['idno'] != null) {
		data.idno = json['idno']?.toString();
	}
	if (json['orgid'] != null) {
		data.orgid = json['orgid']?.toString();
	}
	if (json['chsname'] != null) {
		data.chsname = json['chsname']?.toString();
	}
	if (json['ename'] != null) {
		data.ename = json['ename']?.toString();
	}
	if (json['age'] != null) {
		data.age = json['age']?.toInt();
	}
	return data;
}

Map<String, dynamic> userInfoEntityToJson(UserInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['orderno'] = entity.orderno;
	data['roleid'] = entity.roleid;
	data['remark'] = entity.remark;
	data['title'] = entity.title;
	data['type'] = entity.type;
	data['orgname'] = entity.orgname;
	data['id'] = entity.id;
	data['email'] = entity.email;
	data['ownerprojectid'] = entity.ownerprojectid;
	data['rolename'] = entity.rolename;
	data['avater'] = entity.avater;
	data['directleader'] = entity.directleader;
	data['sex'] = entity.sex;
	data['userno'] = entity.userno;
	data['mobile'] = entity.mobile;
	data['immediateleader'] = entity.immediateleader;
	data['idno'] = entity.idno;
	data['orgid'] = entity.orgid;
	data['chsname'] = entity.chsname;
	data['ename'] = entity.ename;
	data['age'] = entity.age;
	return data;
}