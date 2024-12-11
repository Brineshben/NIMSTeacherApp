import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatController.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';

import 'package:teacherapp/Models/api_models/parent_chat_list_api_model.dart';
import 'package:teacherapp/Models/api_models/parent_chatting_model.dart';
import 'package:teacherapp/Models/api_models/sent_msg_by_teacher_model.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/constant_function.dart';

class ParentDbController extends GetxController {
  late Database db;

  bool isResentWorking = false;

  // List<RoomList> chatRoomList = [];
  // List<MessageModel> messageList = [];
  // List<ClassTeacherGroup>? chatRoomList;
  // List<MessageModel>? messageList;

  Future<void> initDatabaseForChat() async {
    db = await openDatabase(join(await getDatabasesPath(), 'MessageDB'),
        version: 1, onCreate: (Database db, int version) {});
    // for creating the table for teachers chat room //
    createRoomListTable();
  }

  Future<void> createRoomListTable() async {
// Create feed view chatRoomList table

    await db.execute('''
        CREATE TABLE IF NOT EXISTS "teacherWithParentChatRoomList"(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          class TEXT,
          batch TEXT,
          subject_id TEXT,
          subject TEXT,
          parentId TEXT,
          parentName TEXT,
          relation TEXT,
          studentName TEXT,
          unread_count TEXT
        )
        ''');

    // Create feed view chatRoomList LastMessage table with foreign key to RoomList table
    await db.execute('''
        CREATE TABLE IF NOT EXISTS "LastMessageteacherWithParentchatRoomList" (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          room_id INTEGER,
          type TEXT,
          message TEXT,
          message_file TEXT,
          file_name TEXT,
          message_audio TEXT,
          message_from_id TEXT,
          message_from TEXT,
          sand_at TEXT,
          read INTEGER,
          FOREIGN KEY (room_id) REFERENCES RoomList (id) ON DELETE CASCADE
        )
        ''');
  }

  Future<void> insertRoomList(Datum roomList) async {
    // Insert into teacherchatRoomList
    int roomId = await db.insert('teacherWithParentChatRoomList', {
      'class': roomList.datumClass,
      'batch': roomList.batch,
      'subject_id': roomList.subjectId,
      'subject': roomList.subjectName,
      'parentId': roomList.parentId,
      'parentName': roomList.parentName,
      'relation': roomList.relation,
      'studentName': roomList.studentName,
      'unread_count': roomList.unreadCount,
    });

    // Insert each last message into LastMessageteacherchatRoomList
    // for (var message in roomList.lastMessage!) {
    LastMessage? message = roomList.lastMessage;
    if (message != null) {
      await db.insert('LastMessageteacherWithParentchatRoomList', {
        'room_id': roomId,
        'type': message.type,
        'message': message.message,
        'message_file': message.messageFile,
        'file_name': message.fileName,
        'message_audio': message.messageAudio,
        'message_from_id': message.messageFromId,
        'message_from': "",
        'sand_at': message.sandAt.toString(),
        'read': message.read == true ? 1 : 0,
      });
    }
    // }
  }

  Future<List<Datum>> getRoomList() async {
    // Query all rows from teacherWithParentChatRoomList
    final List<Map<String, dynamic>> roomMaps =
        await db.query('teacherWithParentChatRoomList');

    // Initialize the room list
    List<Datum> roomList = [];

    for (var room in roomMaps) {
      // Create a ClassTeacherGroup instance
      Datum roomData = Datum(
        datumClass: room['class'],
        batch: room['batch'],
        subjectId: room['subject_id'],
        subjectName: room['subject'],
        parentId: room['parentId'],
        parentName: room['parentName'],
        relation: room['relation'],
        studentName: room['studentName'],
        unreadCount: room['unread_count'],
        lastMessage: null, // This will be set to a LastMessage instance
      );

      // Fetch the latest associated LastMessage for the current room
      final List<Map<String, dynamic>> messageMaps = await db.query(
        'LastMessageteacherWithParentchatRoomList',
        where: 'room_id = ?',
        whereArgs: [room['id']],
        orderBy: 'id DESC', // Get the most recent message
        limit: 1,
      );

      print(
          "parent room list Arun 2----------------------- ${messageMaps.length}");

      if (messageMaps.isNotEmpty) {
        var messageMap = messageMaps.first;
        roomData.lastMessage = LastMessage(
          type: messageMap['type'],
          message: messageMap['message'],
          messageFile: messageMap['message_file'],
          fileName: messageMap['file_name'],
          messageAudio: messageMap['message_audio'],
          messageFromId: messageMap['message_from_id'],
          // messageFrom: messageMap['message_from'],
          sandAt: DateTime.tryParse(messageMap['sand_at'] ?? ""),
          read: messageMap['read'] == 1,
        );
      }

      // Add the roomData to the list
      roomList.add(roomData);
    }

    print("parent room list ----------------------- $roomList");

    return roomList;
  }

  Future storeChatRoomDatatoDB(List<Datum> roomList) async {
    await db.rawDelete('DELETE FROM teacherWithParentChatRoomList');
    await db.rawDelete('DELETE FROM LastMessageteacherWithParentchatRoomList');
    roomList.forEach(
      (element) async {
        await insertRoomList(element);
      },
    );
    // await chatRoomUIUpdate();
  }

  //-------------------------------------------------------------------------- DB for chat page --------------------------------------------------------------------------//

  Future<void> createMessageTable({
    required String parentId,
    required String studentclass,
    required String batch,
  }) async {
    String? teacherId = Get.find<UserAuthController>().userData.value.userId;
    String portion = studentclass + batch + teacherId! + parentId;
    String messageTableName = "message$portion";
    String repliesTableName = "replies$portion";
    String incomingreactsTableName = "incoming_reacts$portion";

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
      message_from_pic TEXT
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
  }

  Future<void> insertMessage(ParentMsgData message, String messageTableName,
      String replayTableName, String incomingReactTableName) async {
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
      'message_from_pic': message.messageFromPic,
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
        'sand_at': "",
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
  }

  Future<List<ParentMsgData>> getAllMessages({
    required String parentId,
    required String studentclass,
    required String batch,
  }) async {
    String? teacherId = Get.find<UserAuthController>().userData.value.userId;
    String portion = studentclass + batch + teacherId! + parentId;
    String messageTableName = "message$portion";
    String repliesTableName = "replies$portion";
    String incomingreactsTableName = "incoming_reacts$portion";
    // Query all messages from the 'messages' table
    List<Map<String, dynamic>> messageResults =
        await db.query(messageTableName);

    // Initialize an empty list to store all MessageModel objects
    List<ParentMsgData> messages = [];

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
          // sandAt: replyData['sand_at'],
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

      // Construct the MessageModel
      ParentMsgData message = ParentMsgData(
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
        messageFromPic: messageData['message_from_pic'],
        incomingReact: incomingReactList,
      );

      // Add the message to the list
      messages.add(message);
    }

    // Return the list of messages
    return messages;
  }

  Future<void> storeMessageDatatoDB({
    required List<ParentMsgData> messageList,
    required String parentId,
    required String studentclass,
    required String batch,
  }) async {
    String? teacherId = Get.find<UserAuthController>().userData.value.userId;
    String portion = studentclass + batch + teacherId! + parentId;
    String messageTableName = "message$portion";
    String repliesTableName = "replies$portion";
    String incomingreactsTableName = "incoming_reacts$portion";

    // final tempList = await getAllMessages(teacherId: teacherId, subId: subId);

    // checkUnsentMessage()

    await db.rawDelete('DELETE FROM $messageTableName');
    await db.rawDelete('DELETE FROM $repliesTableName');
    await db.rawDelete('DELETE FROM $incomingreactsTableName');
    for (ParentMsgData element in messageList) {
      await insertMessage(
          element, messageTableName, repliesTableName, incomingreactsTableName);
    }
  }

//   Future<int> deleteMessageRowById({
//     required String tableName,
//     required int id,
//   }) async {
//     try {
//       return await db.delete(
//         tableName,
//         where: 'message_id = ?',
//         whereArgs: [id],
//       );
//     } catch (e) {
//       print('Error deleting row by ID: $e');
//       return 0;
//     }
//   }

//   Future<bool> checkNameExists(
//     String name,
//     String tableName,
//   ) async {
//     List<Map> result = await db.query(
//       tableName, // Replace with your table name
//       where: 'name = ?',
//       whereArgs: [name],
//     );

//     // If the result is not empty, the name exists
//     return result.isNotEmpty;
//   }

  Future<void> sendMessageLocally(
      {required String teacherId,
      required String subId,
      required String className,
      required String batch,
      required String parentId,
      required String subject,
      // required String studentId,
      // required String studentName,
      required String? filePath,
      required String messageId,
      required String message,
      required String? replyId,
      required bool isForward,
      required ParentMsgData? replayMessageData
      // required BuildContext context,
      }) async {
    String portion = parentId + teacherId + subId + className + batch;
    String messageTableName = "unsentmessage$portion";
    // String repliesTableName = "replies$portion";
    // String incomingreactsTableName = "incoming_reacts$portion";
    // Create the main messages table if it doesn't exist
    print("local working ------------------- 1");

    await db.execute('''
  CREATE TABLE IF NOT EXISTS $messageTableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    class TEXT,
    batch TEXT,
    subject_id TEXT,
    parent_id TEXT,
    subject TEXT,
    teacher_id TEXT,
    filePath TEXT,
    message_id TEXT,
    message TEXT,
    reply_id TEXT,
    is_forward INTEGER,
    sand_at TEXT,
    reply_type TEXT,
    reply_message TEXT,
    reply_file TEXT,
    reply_fileName TEXT,
    reply_from_id TEXT,
    reply_from_name TEXT
  )
''');

//  student_Id TEXT,
//     student_Name TEXT,

    Map<String, dynamic> values = {
      'class': className,
      'batch': batch,
      'subject_id': subId,
      'parent_id': parentId,
      'subject': subject,
      'teacher_id': teacherId,
      'filePath': filePath,
      'message_id': messageId,
      'message': message,
      'reply_id': replyId,
      'is_forward': isForward,
      'sand_at': DateTime.now().toString(),
      'reply_type': replayMessageData?.type,
      'reply_message': replayMessageData?.message,
      'reply_file': replayMessageData?.messageFile,
      'reply_fileName': replayMessageData?.fileName,
      'reply_from_id': replayMessageData?.messageFromId,
      'reply_from_name': replayMessageData?.messageFrom
    };

    if (replyId != null && replyId.contains("unsent")) {
      Get.snackbar("Warning",
          "Sorry, you can't reply to a message that hasn't been sent.",
          backgroundColor: Colorutils.white);
    } else {
      await db.insert(
        messageTableName, // Replace with your actual table name
        values,
      );
    }

    // for update List

    Get.find<ParentChattingController>().chatMsgList.value =
        await getAllMessages(
            parentId: parentId, studentclass: className, batch: batch);
    final unsentList = await Get.find<ParentDbController>().getUnSentMessage(
        teacherId: teacherId,
        subId: subId,
        batch: batch,
        className: className,
        parentId: parentId);
    print(
        "Arun Msg Sent working -------------------${await db.query(messageTableName)}");

    if (Get.find<ParentChattingController>().chatMsgList.isEmpty) {
      Get.find<ParentChattingController>().chatMsgList.value = [
        ...unsentList.reversed,
        ...[ParentMsgData()]
      ];
    } else {
      Get.find<ParentChattingController>().chatMsgList.value = [
        ...unsentList.reversed,
        ...Get.find<ParentChattingController>().chatMsgList
      ];
    }

    print(
        "working -------------- ${getUnSentMessage(teacherId: teacherId, subId: subId, batch: batch, className: className, parentId: parentId)}");
    print(
        "working -------------- ${Get.find<ParentChattingController>().chatMsgList}");
  }

  Future<List<ParentMsgData>> getUnSentMessage({
    required String teacherId,
    required String subId,
    required String parentId,
    required String className,
    required String batch,
  }) async {
    String portion = parentId + teacherId + subId + className + batch;
    String messageTableName = "unsentmessage$portion";
    await db.execute('''
  CREATE TABLE IF NOT EXISTS $messageTableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    class TEXT,
    batch TEXT,
    subject_id TEXT,
    parent_id TEXT,
    subject TEXT,
    teacher_id TEXT,
    filePath TEXT,
    message_id TEXT,
    message TEXT,
    message_file TEXT,
    reply_id TEXT,
    is_forward INTEGER,
    sand_at TEXT,
    reply_type TEXT,
    reply_message TEXT,
    reply_file TEXT,
    reply_fileName TEXT,
    reply_from_id TEXT,
    reply_from_name TEXT
  )
  ''');
    print("local working ------------------- 2");

    List<ParentMsgData> messageList = [];
    List<Map<String, dynamic>> data = await db.query(messageTableName);

    log("local working ------------------- $data");

    for (var messageData in data) {
      String type;

      if (messageData['filePath'].toString().split(".").last == "wav") {
        type = "audio";
      } else if (messageData['filePath'] == null) {
        type = "text";
      } else {
        type = "file";
      }

      // print(
      //     "File path =============== ${messageData['filePath'].toString().split(".").last}");

      ParentMsgData message = ParentMsgData(
        messageId: "${messageData['message_id']}/${messageData['id']}",
        type: type,
        message: messageData['message'],
        subjectName: messageData['subject_name'],
        // subjectId: messageData['subject_id'],
        messageFile: type == "file" ? messageData['filePath'] : null,
        fileName: type == "file"
            ? messageData['filePath'].toString().split("/").last
            : null,
        messageAudio: type == "audio" ? messageData['filePath'] : null,
        messageFromId: teacherId,
        messageFrom: "dsad",
        sendAt: messageData['sand_at'],
        appMsgId: null,
        read: false,
        replyId: messageData['reply_id'].toString().contains("unsent")
            ? messageData['reply_id'].toString().split("/").last
            : messageData['reply_id'],
        // replyId: null,
        replyData: messageData['reply_id'] == null
            ? null
            : ReplyData(
                messageId: messageData['reply_id'] == null
                    ? null
                    : int.parse(
                        messageData['reply_id'].toString().contains("unsent")
                            ? messageData['reply_id'].toString().split("/").last
                            : messageData['reply_id']),
                type: messageData['reply_type'],
                message: messageData['reply_message'],
                messageFile: messageData['reply_file'],
                fileName: messageData['reply_fileName'],
                messageFromId: messageData['reply_from_id'],
                messageFromName: messageData['reply_from_name'],
              ),
        isForward: false,
        myReact: null,
        messageFromPic: null,
        incomingReact: [],
      );

      messageList.add(message);
    }
    print("working 2 ------------- ${messageList}");
    return messageList;
  }

  resentUnsentMessage({
    required String teacherId,
    required String parentId,
    required String subId,
    required BuildContext context,
    required String studentClass,
    required String batch,
  }) async {
    print("Resent Working -------------------- ");
    String portion = parentId + teacherId + subId + studentClass + batch;
    String messageTableName = "unsentmessage$portion";
    List<Map<String, dynamic>> unsentList = await db.query(messageTableName);

    if (unsentList.isNotEmpty) {
      isResentWorking = true;
      await checkInternetWithOutSnacksbar(
        function: () async {
          await db.rawDelete('DELETE FROM $messageTableName');
          for (var msg in unsentList) {
            try {
              await checkInternetWithOutSnacksbar(
                function: () async {
                  final replayId = msg['reply_id'].toString().contains("unsent")
                      ? msg['reply_id'].toString().split("/").last
                      : msg['reply_id'];

                  if (msg['filePath'] != null) {
                    // for sent attached msg //
                    print(
                        "Arun Msg Sent working ------- resent----------- ${msg['parent_id']}");

                    await Get.find<ParentChattingController>().sendAttach(
                        context: context,
                        classs: msg['class'],
                        batch: msg['batch'],
                        subId: msg['subject_id'],
                        parent: [msg['parent_id']],
                        sub: msg['subject'],
                        teacherId: msg['teacher_id'],
                        filePath: msg['filePath'],
                        // filePath:
                        //     Get.find<MessageController>().audioPath.value ??
                        //         Get.find<MessageController>().filePath.value,
                        message: msg['message']);
                    // await Get.find<MessageController>().periodicGetMsgList(
                    //     context: context,
                    //     studentClass: studentClass,
                    //     batch: batch,
                    //     subId: subId,
                    //     parentId: Get.find<StudentController>().parentId,
                    //     teacherId: teacherId,
                    //     studentId: Get.find<StudentController>()
                    //         .studentList[Get.find<StudentController>()
                    //             .currentStudentIndex
                    //             .value]
                    //         .userId!);
                  } else {
                    // for sent text msg //
                    final sentData = SentMsgByTeacherModel(
                      classs: msg['class'],
                      batch: msg['batch'],
                      subjectId: msg['subject_id'],
                      parents: [msg['parent_id']],
                      subject: msg['subject'],
                      fileData: null,
                      message: msg['message'],
                      messageFrom: teacherId,
                      replyId: replayId,
                    );
                    await Get.find<ParentChattingController>()
                        .sendAttachMsg(sentMsgData: sentData, context: context);
                    print("refrshh ---------------------2 work");
                    await Get.find<ParentChattingController>()
                        .fetchParentMsgListPeriodically(ParentChattingReqModel(
                            batch: batch,
                            classs: studentClass,
                            schoolId:
                                UserAuthController().userData.value.schoolId!));
                  }
                },
              );
            } catch (e) {}
          }
        },
      ).then(
        (value) {
          isResentWorking = false;
        },
      );
    } else {
      print("Nothing working");
    }
  }

  Future<void> deleteMessageLocally({
    required String teacherId,
    required String subId,
    required String messageId,
    required String studentClass,
    required String batch,
    required String parentId,
  }) async {
    String portion = parentId + teacherId + subId + studentClass + batch;
    String messageTableName = "unsentmessage$portion";
    await db.delete(
      messageTableName, // Replace with your table name
      where: 'id = ?', // Specify the column for the WHERE clause
      whereArgs: [messageId], // Pass the id value to delete
    );
    // for update List

    Get.find<ParentChattingController>().chatMsgList.value =
        await Get.find<ParentDbController>().getAllMessages(
            batch: batch, parentId: parentId, studentclass: studentClass);
    final unsentList = await Get.find<ParentDbController>().getUnSentMessage(
        teacherId: teacherId,
        subId: subId,
        parentId: parentId,
        className: studentClass,
        batch: batch);

    if (Get.find<ParentChattingController>().chatMsgList.isEmpty) {
      Get.find<ParentChattingController>().chatMsgList.value = [
        ...unsentList.reversed,
        ...[ParentMsgData()]
      ];
    } else {
      Get.find<ParentChattingController>().chatMsgList.value = [
        ...unsentList.reversed,
        ...Get.find<ParentChattingController>().chatMsgList
      ];
    }
  }

//   Future<void> dowloadMediaToDB({
//     required String messageId,
//     required String url,
//     required String type,
//   }) async {
//     String mediaTableName = "mediatable$type";

//     await db.execute('''
//     CREATE TABLE IF NOT EXISTS $mediaTableName (
//      id INTEGER PRIMARY KEY AUTOINCREMENT,
//       filePath TEXT,
//       message_id TEXT,
//       file_name TEXT UNIQUE,
//       file_url TEXT,
//       type TEXT
//      )
//     ''');
//     final fileName = url.split("/").last;
//     final path = await downloadFile(url, fileName);

//     Map<String, dynamic> values = {
//       'filePath': path,
//       'message_id': messageId,
//       'file_name': fileName,
//       'file_url': url,
//       'type': type
//     };

//     await db.insert(
//       mediaTableName,
//       values,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   uiUpdate() async {
//     update();
//   }

//   Future<void> dowloadAudioWaveDataToDB({
//     required String messageId,
//     required List<double> audioData,
//     required String duration,
//     required String type,
//   }) async {
//     String audioTableName = "audiotable$type";

//     await db.execute('''
//     CREATE TABLE IF NOT EXISTS $audioTableName (
//      id INTEGER PRIMARY KEY AUTOINCREMENT,
//       message_id TEXT UNIQUE,
//       audioData TEXT,
//       duration TEXT,
//       type TEXT
//      )
//     ''');

//     String jsonString = jsonEncode(audioData);

//     Map<String, dynamic> values = {
//       'message_id': messageId,
//       'audioData': jsonString,
//       'duration': duration,
//       'type': type
//     };

//     await db.insert(
//       audioTableName,
//       values,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<String?> getFilePathByFileName({
//     required String url,
//     required String type,
//   }) async {
//     String mediaTableName = "mediatable$type";
//     await db.execute('''
//     CREATE TABLE IF NOT EXISTS $mediaTableName (
//      id INTEGER PRIMARY KEY AUTOINCREMENT,
//       filePath TEXT,
//       message_id TEXT,
//       file_name TEXT UNIQUE,
//       file_url TEXT,
//       type TEXT
//      )
//     ''');
//     // Query the database to get the record with the specified file_name
//     final List<Map<String, dynamic>> result = await db.query(
//       mediaTableName,
//       columns: ['filePath'], // Specify the column to retrieve
//       where: 'file_name = ?',
//       whereArgs: [url.split("/").last],
//     );

//     // If a record is found, return the filePath, otherwise return null
//     if (result.isNotEmpty) {
//       return result.first['filePath'] as String?;
//     } else {
//       return null; // File not found
//     }
//   }

//   Future<Duration?> getAudiofileDurationData({
//     required String messageId,
//     required String type,
//   }) async {
//     String audioTableName = "audiotable$type";
//     await db.execute('''
//     CREATE TABLE IF NOT EXISTS $audioTableName (
//      id INTEGER PRIMARY KEY AUTOINCREMENT,
//       message_id TEXT UNIQUE,
//       audioData TEXT,
//       duration TEXT,
//       type TEXT
//      )
//     ''');

//     // Query the database to get the record with the specified file_name
//     final List<Map<String, dynamic>> result = await db.query(
//       audioTableName,
//       columns: ['duration'], // Specify the column to retrieve
//       where: 'message_id = ?',
//       whereArgs: [messageId],
//     );

//     // If a record is found, return the filePath, otherwise return null
//     if (result.isNotEmpty) {
//       Duration duration = parseDuration(result.first['duration'] as String);

//       return duration;
//     } else {
//       return null; // File not found
//     }
//   }

//   Future<List<double>?> getAudiofileWaveData({
//     required String messageId,
//     required String type,
//   }) async {
//     String audioTableName = "audiotable$type";

//     await db.execute('''
//     CREATE TABLE IF NOT EXISTS $audioTableName (
//      id INTEGER PRIMARY KEY AUTOINCREMENT,
//       message_id TEXT UNIQUE,
//       audioData TEXT,
//       duration TEXT,
//       type TEXT
//      )
//     ''');

//     final data = await db.query(audioTableName);
//     // log("data ------------------ $data");

//     // Query the database to get the record with the specified file_name
//     final List<Map<String, dynamic>> result = await db.query(
//       audioTableName,
//       columns: ['audioData'], // Specify the column to retrieve
//       where: 'message_id = ?',
//       whereArgs: [messageId],
//     );

//     // If a record is found, return the filePath, otherwise return null
//     if (result.isNotEmpty) {
//       List<dynamic> decoded = jsonDecode(result.first['audioData']);
//       List<double> audioData = decoded.map((e) => e as double).toList();
//       return audioData;
//     } else {
//       return null; // File not found
//     }
//   }

//   Future<void> deleteMessageDBLogout() async {
//     String dbPath = join(await getDatabasesPath(), 'MessageDB');
//     await deleteDatabase(dbPath);
//     print("Database deleted successfully");
//   }

//   // Future<String> downloadFile(String url, String fileName) async {
//   //   try {
//   //     String filePath;
//   //     final directory = await getDownloadsDirectory();
//   //     if (directory != null) {
//   //       filePath = join(directory.path, fileName);
//   //     } else {}

//   //     // Download the file
//   //     await Dio().download(url, filePath);

//   //     return filePath;
//   //   } catch (e) {
//   //     print('Failed to download file: $e');
//   //     throw e;
//   //   }
//   // }
// }

// Future<void> requestStoragePermission() async {
//   var status = await Permission.storage.request();
//   if (status.isGranted) {
//     print("Storage permission granted.");
//   } else if (status.isDenied) {
//     print("Storage permission denied.");
//   } else if (status.isPermanentlyDenied) {
//     print(
//         "Storage permission permanently denied. Please enable it from settings.");
//   }
// }

// // Future<void> _scanFile(String path) async {
// //   try {
// //     if (Platform.isAndroid) {
// //       // Notify the media scanner
// //       MediaScanner.loadMedia(path: path);
// //       print('Scanning file: $path');
// //     }
// //   } catch (e) {
// //     print('Failed to scan file: $e');
// //   }
// // }

// // Function to download a file from a URL and save it to a specific directory
// Future<String> downloadFile(String url, String fileName) async {
//   await requestStoragePermission(); // Ensure storage permission is granted

//   try {
//     // Define the download directory and create a new folder if it doesn't exist
//     // Directory downloadDirectory = Directory('/storage/emulated/0/Download');
//     Directory? downloadDirectory = await getApplicationDocumentsDirectory();
//     Directory schoolDiaryFolder =
//         Directory('${downloadDirectory.path}/School Diary');

//     // Create the SchoolDiary folder
//     if (!(await schoolDiaryFolder.exists())) {
//       await schoolDiaryFolder.create(recursive: true);
//     }

//     // Set the path where the file will be saved
//     String savePath = '${schoolDiaryFolder.path}/$fileName';

//     // Download the file from the URL
//     var response = await Dio().download(url, savePath);

//     // Check if the download was successful
//     if (response.statusCode == 200) {
//       print('File downloaded to: $savePath');
//       // Notify the media scanner to make the file visible in the gallery
//       // await _scanFile(savePath);
//     } else {
//       print('Failed to download file: ${response.statusCode}');
//     }

//     return savePath; // Return the path of the downloaded file
//   } catch (e) {
//     print('Failed to download file: $e');
//     throw e; // Rethrow the error for further handling
//   }

  //-------------------------------------------------------------------------- DB for chat page --------------------------------------------------------------------------//
}
