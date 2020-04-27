
//聊天列表项实体
class ImMessageItem{

  //用户id
  String userId;
  //姓名
  String userName;
  //头像
  String userHeadPic;
  //最后一条消息
  String lastMessage;
  //最后一条消息类型
  String lastMessageType;
  //最后一条消息时间
  int lastMessageTime;
  //未读消息总数
  int notReadCount;

  ImMessageItem({this.userId,this.userName,this.userHeadPic,this.lastMessage,this.lastMessageType,this.lastMessageTime,this.notReadCount=0});

}