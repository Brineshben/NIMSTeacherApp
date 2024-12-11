import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Models/api_models/chat_feed_view_model.dart';
import 'package:teacherapp/Models/api_models/grouped_view_list_api_model.dart';

class GroupDbController extends GetxController {
  late Database db;

  bool isResentWorking = false;

  List<RoomData>? chatRoomList;

  Future<void> initDatabaseForChat() async {
    db = await openDatabase(join(await getDatabasesPath(), 'MessageDB'),
        version: 1, onCreate: (Database db, int version) {});
    // for creating the table for teachers chat room //
    createRoomListTable();
  }

  Future<void> createRoomListTable() async {
// Create feed view chatRoomList table

    await db.execute('''
        CREATE TABLE IF NOT EXISTS "groupchatRoomList"(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          class TEXT,
          batch TEXT,
          subject_id TEXT,
          subject TEXT,
          message_from TEXT,
          teacher_name TEXT,
          unread_count TEXT
        )
        ''');

    // Create feed view chatRoomList LastMessage table with foreign key to RoomList table

    await db.execute('''
        CREATE TABLE IF NOT EXISTS "lastMessageGroupchatRoomList" (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          room_id INTEGER,
          type TEXT,
          message TEXT,
          message_file TEXT,
          file_name TEXT,
          message_audio TEXT,
          message_from_id TEXT,
          sand_at TEXT,
          read INTEGER,
          FOREIGN KEY (room_id) REFERENCES RoomList (id) ON DELETE CASCADE
        )
        ''');
  }

  Future<void> insertRoomList(RoomData roomList) async {
    // Insert into teacherchatRoomList
    int roomId = await db.insert('groupchatRoomList', {
      'class': roomList.classs,
      'batch': roomList.batch,
      'subject_id': roomList.subjectId,
      'subject': roomList.subjectName,
      'message_from': roomList.messageFrom,
      'teacher_name': roomList.teacherName,
      'unread_count': roomList.unreadCount,
    });

    // Insert each last message into LastMessageteacherchatRoomList

    await db.insert('lastMessageGroupchatRoomList', {
      'room_id': roomId,
      'type': roomList.lastMessage?.type,
      'message': roomList.lastMessage?.message,
      'message_file': roomList.lastMessage?.messageFile,
      'file_name': roomList.lastMessage?.fileName,
      'message_audio': roomList.lastMessage?.messageAudio,
      'message_from_id': roomList.lastMessage?.messageFromId,
      'sand_at': roomList.lastMessage?.sandAt,
      'read': roomList.lastMessage?.read == true ? 1 : 0,
    });
  }

  Future<List<RoomData>> getRoomList() async {
    // Initialize the room list
    List<RoomData> roomList = [];
    // Query all rows from teacherchatRoomList
    try {
      final List<Map<String, dynamic>> roomMaps =
          await db.query('groupchatRoomList');

      print("group chat ----------------- $roomMaps");

      for (var room in roomMaps) {
        // Create a ClassTeacherGroup instance
        RoomData roomData = RoomData(
          classs: room['class'],
          batch: room['batch'],
          subjectId: room['subject_id'],
          subjectName: room['subject'],
          messageFrom: room['message_from'],
          teacherName: room['teacher_name'],
          unreadCount: room['unread_count'],
          lastMessage: null, // This will be filled next
        );

        // Fetch associated LastMessages for the current room
        final List<Map<String, dynamic>> messageMaps = await db.query(
          'lastMessageGroupchatRoomList',
          where: 'room_id = ?',
          whereArgs: [room['id']],
        );

        // Convert message maps into LastMessage objects

        print("group chat last message----------------- $messageMaps");

        for (var lastMessage in messageMaps) {
          roomData.lastMessage = LastMessageGroupedView(
              type: lastMessage['type'],
              message: lastMessage['message'],
              messageFile: lastMessage['message_file'],
              fileName: lastMessage['file_name'],
              messageAudio: lastMessage['message_audio'],
              messageFromId: lastMessage['message_from_id'],
              sandAt: lastMessage['sand_at'],
              read: lastMessage['read'] == 1 ? true : false);
        }

        // Add the roomData to the list
        roomList.add(roomData);
      }
    } catch (e) {
      print('group error ------------------------- $e');
    }
    return roomList;
  }

  Future storeChatRoomDatatoDB(List<RoomData> roomList) async {
    await db.rawDelete('DELETE FROM groupchatRoomList');
    await db.rawDelete('DELETE FROM lastMessageGroupchatRoomList');
    roomList.forEach(
      (element) async {
        await insertRoomList(element);
      },
    );
    update();
  }

  //-------------------------------------------------------------------------- DB for chat page --------------------------------------------------------------------------//

  Future<void> createMessageTable({
    required String subId,
    required String studentclass,
    required String batch,
  }) async {
    String? teacherId = Get.find<UserAuthController>().userData.value.userId;
    String portion = studentclass + batch + teacherId! + subId;
    String messageTableName = "group_message$portion";
    String repliesTableName = "group_replies$portion";
    String incomingreactsTableName = "group_incoming_reacts$portion";
    String studentDataTableName = "group_student_data$portion";

    // Create the main messages table if it doesn't exist
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $messageTableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      message_id TEXT,
      type TEXT,
      message TEXT,
      subject_name TEXT,
      subject_id TEXT,
      message_file TEXT,
      file_name TEXT,
      message_audio TEXT,
      message_from_id TEXT,
      message_from TEXT,
      sand_at TEXT,
      app_msg_id TEXT,
      read INTEGER,
      reply_id TEXT,
      is_forward INTEGER,
      my_react TEXT,
      message_from_pic TEXT,
      role_name
    )
  ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $repliesTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reply_message_id INTEGER,
        message_id INTEGER,
        type TEXT,
        message TEXT,
        message_file TEXT,
        file_name TEXT,
        message_audio TEXT,
        message_from_id TEXT,
        message_from_name TEXT,
        sand_at TEXT,
        FOREIGN KEY (message_id) REFERENCES $messageTableName(id) ON DELETE CASCADE
      )
    ''');

    // Create the incoming_reacts table if it doesn't exist
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $incomingreactsTableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      message_id INTEGER,
      react TEXT,
      react_by TEXT,
      FOREIGN KEY (message_id) REFERENCES $messageTableName(id) ON DELETE CASCADE
    )
  ''');

    // Create the student_data table if it doesn't exist
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $studentDataTableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      message_id INTEGER,
      studentName TEXT,
      relation TEXT,
      FOREIGN KEY (message_id) REFERENCES $messageTableName(id) ON DELETE CASCADE
    )
  ''');
  }

  Future<void> insertMessage(
      MsgData message,
      String messageTableName,
      String replayTableName,
      String incomingReactTableName,
      String studentDataTableName) async {
    // Insert the message into the 'messages' table

    int messageId = await db.insert(messageTableName, {
      'message_id': message.messageId,
      'type': message.type,
      'message': message.message,
      'subject_name': message.subjectName,
      'subject_id': "",
      'message_file': message.messageFile,
      'file_name': message.fileName,
      'message_audio': message.messageAudio,
      'message_from_id': message.messageFromId,
      'message_from': message.messageFrom,
      'sand_at': message
          .sendAt, // Assuming it's a String (or convert DateTime if needed)
      'app_msg_id': message.appMsgId,
      'read': message.read == true ? 1 : 0,
      'reply_id': message.replyId,
      'is_forward': message.isForward == true ? 1 : 0,
      'my_react': message.myReact,
      'message_from_pic': message.userImage,
      'role_name': message.roleName,
    });

    // Insert the reply message if exists
    if (message.replyData != null) {
      await db.insert(replayTableName, {
        'reply_message_id': messageId, // Linking to the main message
        'message_id': message.replyData?.messageId,
        'type': message.replyData?.type,
        'message': message.replyData?.message,
        'message_file': message.replyData?.messageFile,
        'file_name': message.replyData?.fileName,
        'message_audio': message.replyData?.messageAudio,
        'message_from_id': message.replyData?.messageFromId,
        'message_from_name': message.replyData?.messageFromName,
        'sand_at': message.replyData?.sandAt,
      });
    }

    // Insert the incoming reactions if any
    if (message.incomingReact != null) {
      for (var react in message.incomingReact!) {
        await db.insert(incomingReactTableName, {
          'message_id': messageId, // Linking to the main message
          'react': react.react,
          'react_by': react.reactBy,
        });
      }
    }
    // Insert the incoming reactions if any
    if (message.studentData != null) {
      for (var student in message.studentData!) {
        await db.insert(studentDataTableName, {
          'message_id': messageId, // Linking to the main message
          'studentName': student.studentName,
          'relation': student.relation,
        });
      }
    }
  }

  Future<List<MsgData>> getAllMessages({
    required String subId,
    required String studentclass,
    required String batch,
  }) async {
    String? teacherId = Get.find<UserAuthController>().userData.value.userId;
    String portion = studentclass + batch + teacherId! + subId;
    String messageTableName = "group_message$portion";
    String repliesTableName = "group_replies$portion";
    String incomingreactsTableName = "group_incoming_reacts$portion";
    String studentDataTableName = "group_student_data$portion";
    // Query all messages from the 'messages' table
    List<Map<String, dynamic>> messageResults =
        await db.query(messageTableName);

    // Initialize an empty list to store all MessageModel objects
    List<MsgData> messages = [];

    // Loop through each message result and process the related data
    for (var messageData in messageResults) {
      // Query the reply message if it exists
      List<Map<String, dynamic>> replyResult = await db.query(
        repliesTableName,
        where: 'reply_message_id = ?',
        whereArgs: [messageData['id']],
      );

      ReplyData? reply;
      if (replyResult.isNotEmpty) {
        Map<String, dynamic> replyData = replyResult.first;
        reply = ReplyData(
          messageId: replyData['message_id'],
          type: replyData['type'],
          message: replyData['message'],
          messageFile: replyData['message_file'],
          fileName: replyData['file_name'],
          messageAudio: replyData['message_audio'],
          messageFromId: replyData['message_from_id'],
          messageFromName: replyData['message_from_name'],
          sandAt: replyData['sand_at'],
        );
      }

      // Query the incoming reactions if any
      List<Map<String, dynamic>> reactResults = await db.query(
        incomingreactsTableName,
        where: 'message_id = ?',
        whereArgs: [messageData['id']],
      );

      List<IncomingReact> incomingReactList = [];
      for (var reactData in reactResults) {
        incomingReactList.add(IncomingReact(
          react: reactData['react'],
          reactBy: reactData['react_by'],
        ));
      }

      List<Map<String, dynamic>> studentDataResults = await db.query(
        studentDataTableName,
        where: 'message_id = ?',
        whereArgs: [messageData['id']],
      );

      List<StudentData> studentDataList = [];
      for (var student in studentDataResults) {
        studentDataList.add(StudentData(
          studentName: student['studentName'],
          relation: student['relation'],
        ));
      }

      // Construct the MessageModel
      MsgData message = MsgData(
          messageId: messageData['message_id'],
          type: messageData['type'],
          message: messageData['message'],
          subjectName: messageData['subject_name'],
          // subjectId: messageData['subject_id'],
          messageFile: messageData['message_file'],
          fileName: messageData['file_name'],
          messageAudio: messageData['message_audio'],
          messageFromId: messageData['message_from_id'],
          messageFrom: messageData['message_from'],
          sendAt: messageData['sand_at'],
          appMsgId: messageData['app_msg_id'],
          read: messageData['read'] == 1,
          replyId: messageData['reply_id'],
          replyData: reply,
          isForward: messageData['is_forward'] == 1,
          myReact: messageData['my_react'],
          userImage: messageData['message_from_pic'],
          incomingReact: incomingReactList,
          studentData: studentDataList,
          roleName: messageData['role_name']);

      // Add the message to the list
      messages.add(message);
    }

    // Return the list of messages
    return messages;
  }

  Future<void> storeMessageDatatoDB({
    required List<MsgData> messageList,
    required String subId,
    required String studentclass,
    required String batch,
  }) async {
    String? teacherId = Get.find<UserAuthController>().userData.value.userId;
    String portion = studentclass + batch + teacherId! + subId;
    String messageTableName = "group_message$portion";
    String repliesTableName = "group_replies$portion";
    String incomingreactsTableName = "group_incoming_reacts$portion";
    String studentDataTableName = "group_student_data$portion";

    // final tempList = await getAllMessages(teacherId: teacherId, subId: subId);

    // checkUnsentMessage()

    await db.rawDelete('DELETE FROM $messageTableName');
    await db.rawDelete('DELETE FROM $repliesTableName');
    await db.rawDelete('DELETE FROM $incomingreactsTableName');
    for (MsgData element in messageList) {
      await insertMessage(element, messageTableName, repliesTableName,
          incomingreactsTableName, studentDataTableName);
    }
  }
}
