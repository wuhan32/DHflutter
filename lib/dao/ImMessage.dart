import 'package:oa/utils/AuthUtil.dart';
import 'package:oa/utils/Constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


//即时消息Dao
class ImMessageDao {
  //数据库连接
  static Database _dataBase;
  //ImMessageDao实例
  static ImMessageDao imMessageDao;

  //获取实例
  static Future<ImMessageDao> getInstance() async{
    //实例化
    if (imMessageDao == null) {
      imMessageDao = ImMessageDao();
    }
    //开启数据库连接
    if (_dataBase == null) {
      await _openDb();
    }
    return imMessageDao;
  }


  // 插入聊天记录
  Future<void> insert(ImMessage imMessage) async {
    String loginUserId=(await AuthUtil.getUserInfo()).id;
    try{
      if(imMessage.fromUser==loginUserId){
        imMessage.targetUser=imMessage.toUser;
      }else{
        imMessage.targetUser=imMessage.fromUser;
      }
      await _dataBase.insert(ImMessage.tableName, imMessage.toMap());
    }catch(e){
      insert(imMessage);
    }
  }



  //查询消息列表
  Future<List<Map>> getImMessageList()async{
    String loginUserId=(await AuthUtil.getUserInfo()).id;
    List<Map> maps = await _dataBase.query(ImMessage.tableName,
        columns: [
          ImMessage.columnTargetUser,
          "max(${ImMessage.columnTime}) as lastMessageTime",
          'case when ${ImMessage.columnTime}=max(${ImMessage.columnTime}) then ${ImMessage.columnMessage} end as lastMessage',
          '${ImMessage.columnMessageType} as lastMessageType',
          "count(case when ${ImMessage.columnState}=0 then 1 end) as noReadCount"
        ],
        where: '${ImMessage.columnToUser} = ? or ${ImMessage.columnFromUser} = ?',
        groupBy:"${ImMessage.columnTargetUser}",
        orderBy: 'count(case when ${ImMessage.columnState}=0 then 1 end) desc,max(${ImMessage.columnTime}) desc',
        whereArgs: [loginUserId,loginUserId]);
    return maps;
  }




  // 根据 聊天对象ID 查找聊天记录
  Future<List<ImMessage>> getUserMessageList(String toUserId) async {
    String loginUserId=(await AuthUtil.getUserInfo()).id;
    List<ImMessage> userMessageList=List<ImMessage>();
    List<Map> maps = await _dataBase.query(ImMessage.tableName,
        columns: [
          ImMessage.columnId,
          ImMessage.columnFromUser,
          ImMessage.columnToUser,
          ImMessage.columnMessageType,
          ImMessage.columnMessage,
          ImMessage.columnTime,
          ImMessage.columnState
        ],
        orderBy: "${ImMessage.columnTime} asc",
        where: '(${ImMessage.columnToUser} = ? and ${ImMessage.columnFromUser} = ?) or (${ImMessage.columnFromUser} = ? and ${ImMessage.columnToUser} = ?)',
        whereArgs: [toUserId,loginUserId,toUserId,loginUserId]);
    if (maps.length > 0) {
      maps.forEach((map){
        userMessageList.add(ImMessage.fromMap(map));
      });
    }
    return userMessageList;
  }

  //设置消息已读
  Future<int> setMessageReadState(String toUserId)async{
    String loginUserId=(await AuthUtil.getUserInfo()).id;
    return await _dataBase.update(
        ImMessage.tableName,
        {"${ImMessage.columnState}":1},
        where: '(${ImMessage.columnToUser} = ? and ${ImMessage.columnFromUser} = ? and ${ImMessage.columnState} = ?) or (${ImMessage.columnFromUser} = ? and ${ImMessage.columnToUser} = ? and ${ImMessage.columnState} = ?)',
        whereArgs: [toUserId,loginUserId,0,toUserId,loginUserId,0]);
  }


  //统计未读消息总数
  Future<int> loadNotReadTotal()async{
    String loginUserId=(await AuthUtil.getUserInfo()).id;
    List<Map> maps=await _dataBase.query(ImMessage.tableName,columns: [
      "count(case when ${ImMessage.columnState}=0 then 1 end) as notReadTotal"],
      where: '${ImMessage.columnToUser} = ? or ${ImMessage.columnFromUser} = ?',
      whereArgs: [loginUserId,loginUserId]
    );
    return maps[0]["notReadTotal"];
  }


  // 根据 选择用户ID 删除全部聊天记录
  Future<int> deleteChooseMessageRecord(String toUserId) async {
    String loginUserId=(await AuthUtil.getUserInfo()).id;
    int num = await _dataBase.delete(ImMessage.tableName,
        where: '(${ImMessage.columnToUser} = ? and ${ImMessage.columnFromUser} = ?) or (${ImMessage.columnFromUser} = ? and ${ImMessage.columnToUser} = ?)',
        whereArgs: [toUserId,loginUserId,toUserId,loginUserId]);
    return num;
  }



  //删除全部聊天记录
  Future<int> deleteAllMessageRecord() async {
    int num = await _dataBase.delete(ImMessage.tableName);
    return num;
  }


  //开启数据库连接
  static _openDb() async {
    if (_dataBase == null) {
      // 获取数据库文件的存储路径
      String databasesPath = await getDatabasesPath();
      //配置连接参数
      String path = join(databasesPath, Constants.sqlDbName);
      //根据数据库文件路径和数据库版本号创建数据库表
      _dataBase = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
                CREATE TABLE IF NOT EXISTS ${ImMessage.tableName}(
                  ${ImMessage.columnId} INTEGER PRIMARY KEY, 
                  ${ImMessage.columnFromUser} TEXT, 
                  ${ImMessage.columnToUser} TEXT, 
                  ${ImMessage.columnTargetUser} TEXT, 
                  ${ImMessage.columnMessageType} TEXT, 
                  ${ImMessage.columnMessage} TEXT, 
                  ${ImMessage.columnTime} INTEGER,
                  ${ImMessage.columnState} INTEGER)
              ''');
      });
    }
  }


  //关闭数据库连接
  closeDb() async {
    if (_dataBase != null) {
      await _dataBase.close();
      _dataBase = null;
      imMessageDao=null;
    }
  }

}


class ImMessage {
  //id
  int id;
  //消息来源
  String fromUser;
  //消息去向
  String toUser;
  //目标好友(为便于分组统计)
  String targetUser;
  //消息类型
  String messageType;
  //消息内容
  String message;
  //发送时间
  int time;
  //状态
  int state;

  static final String tableName = 'im_message';
  static final String columnId = 'id';
  static final String columnFromUser = 'fromUser';
  static final String columnToUser = 'toUser';
  static final String columnTargetUser = 'targetUser';
  static final String columnMessageType = 'messageType';
  static final String columnMessage = 'message';
  static final String columnTime = 'time';
  static final String columnState = 'state';

  ImMessage({int id, String fromUser, String toUser, String targetUser,String messageType, int time,String message,int state=0}){
      this.id=id;
      this.fromUser=fromUser;
      this.toUser=toUser;
      this.messageType=messageType;
      this.time=time;
      this.message=message;
      this.state=state;
      this.targetUser=targetUser;
  }

  //消息实例转换成map对象
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnFromUser: fromUser,
      columnToUser: toUser,
      columnTargetUser:targetUser,
      columnMessageType: messageType,
      columnMessage: message,
      columnTime: time,
      columnState:state,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  //map对象转换成消息实例
  ImMessage.fromMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.fromUser = map[columnFromUser];
    this.toUser = map[columnToUser];
    this.targetUser=map[columnTargetUser];
    this.messageType = map[columnMessageType];
    this.message = map[columnMessage];
    this.time = map[columnTime];
    this.state=map[columnState]==null?0:map[columnState];
  }
}