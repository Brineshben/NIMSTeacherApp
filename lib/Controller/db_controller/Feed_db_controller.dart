import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Models/api_models/chat_feed_view_model.dart';
import 'package:teacherapp/Models/api_models/chat_group_api_model.dart';
import 'package:teacherapp/Models/api_models/parent_list_api_model.dart';
import 'package:teacherapp/Models/api_models/sent_msg_by_teacher_model.dart';
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/constant_function.dart';

class FeedDBController extends GetxController {
  late Database db;

  bool isResentWorking = false;

  // List<RoomList> chatRoomList = [];
  // List<MessageModel> messageList = [];
  List<ClassTeacherGroup>? chatRoomList;
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
        CREATE TABLE IF NOT EXISTS "teacherchatRoomList"(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          class TEXT,
          batch TEXT,
          subject_id TEXT,
          subject TEXT,
          isClassTeacher INTEGER,
          unread_count INTEGER,
          type TEXT
        )
        ''');

    // Create feed view chatRoomList LastMessage table with foreign key to RoomList table
    await db.execute('''
        CREATE TABLE IF NOT EXISTS "LastMessageteacherchatRoomList" (
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

  Future<void> insertRoomList(ClassTeacherGroup roomList) async {
    // Insert into teacherchatRoomList
    int roomId = await db.insert('teacherchatRoomList', {
      'class': roomList.classTeacherClass,
      'batch': roomList.batch,
      'subject_id': roomList.subjectId,
      'subject': roomList.subjectName,
      'isClassTeacher': roomList.isClassTeacher == true ? 1 : 0,
      'unread_count': roomList.unreadCount,
      'type': roomList.type,
    });

    // Insert each last message into LastMessageteacherchatRoomList
    for (var message in roomList.lastMessage!) {
      await db.insert('LastMessageteacherchatRoomList', {
        'room_id': roomId,
        'type': message.type,
        'message': message.message,
        'message_file': message.messageFile,
        'file_name': message.fileName,
        'message_audio': message.messageAudio,
        'message_from_id': message.messageFromId,
        'message_from': message.messageFrom,
        'sand_at': message.sandAt.toString(),
        'read': message.read == true ? 1 : 0,
      });
    }
  }

  Future<List<ClassTeacherGroup>> getRoomList() async {
    // Query all rows from teacherchatRoomList
    final List<Map<String, dynamic>> roomMaps =
        await db.query('teacherchatRoomList');

    // Initialize the room list
    List<ClassTeacherGroup> roomList = [];

    for (var room in roomMaps) {
      // Create a ClassTeacherGroup instance
      ClassTeacherGroup roomData = ClassTeacherGroup(
        classTeacherClass: room['class'],
        batch: room['batch'],
        subjectId: room['subject_id'],
        subjectName: room['subject'],
        isClassTeacher: room['isClassTeacher'] == 1,
        unreadCount: room['unread_count'],
        type: room['type'],
        lastMessage: [], // This will be filled next
      );

      // Fetch associated LastMessages for the current room
      final List<Map<String, dynamic>> messageMaps = await db.query(
        'LastMessageteacherchatRoomList',
        where: 'room_id = ?',
        whereArgs: [room['id']],
      );

      // Convert message maps into LastMessage objects
      roomData.lastMessage =
          List<LastMessageGroupChat>.generate(messageMaps.length, (i) {
        return LastMessageGroupChat(
          type: messageMaps[i]['type'],
          message: messageMaps[i]['message'],
          messageFile: messageMaps[i]['message_file'],
          fileName: messageMaps[i]['file_name'],
          messageAudio: messageMaps[i]['message_audio'],
          messageFromId: messageMaps[i]['message_from_id'],
          messageFrom: messageMaps[i]['message_from'],
          sandAt: DateTime.tryParse(messageMaps[i]['sand_at'] ?? ""),
          read: messageMaps[i]['read'] == 1,
        );
      });

      // Add the roomData to the list
      roomList.add(roomData);
    }

    return roomList;
  }

  Future<void> chatRoomUIUpdate() async {
    chatRoomList = await getRoomList();
    update();
  }

  Future storeChatRoomDatatoDB(List<ClassTeacherGroup> roomList1,
      List<ClassTeacherGroup> roomList2) async {
    await db.rawDelete('DELETE FROM teacherchatRoomList');
    await db.rawDelete('DELETE FROM LastMessageteacherchatRoomList');
    final roomList = roomList1 + roomList2;
    roomList.forEach(
      (element) async {
        await insertRoomList(element);
      },
    );
    await chatRoomUIUpdate();
  }

  //-------------------------------------------------------------------------- DB for chat page --------------------------------------------------------------------------//

  Future<void> createMessageTable({
    required String subId,
    required String studentclass,
    required String batch,
  }) async {
    String? teacherId = Get.find<UserAuthController>().userData.value.userId;
    String portion = studentclass + batch + teacherId! + subId;
    String messageTableName = "message$portion";
    String repliesTableName = "replies$portion";
    String incomingreactsTableName = "incoming_reacts$portion";
    String studentDataTableName = "student_data$portion";

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
    String messageTableName = "message$portion";
    String repliesTableName = "replies$portion";
    String incomingreactsTableName = "incoming_reacts$portion";
    String studentDataTableName = "student_data$portion";

    await createMessageTable(
        subId: subId, studentclass: studentclass, batch: batch);

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
    String messageTableName = "message$portion";
    String repliesTableName = "replies$portion";
    String incomingreactsTableName = "incoming_reacts$portion";
    String studentDataTableName = "student_data$portion";

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

  Future<int> deleteMessageRowById({
    required String tableName,
    required int id,
  }) async {
    try {
      return await db.delete(
        tableName,
        where: 'message_id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting row by ID: $e');
      return 0;
    }
  }

  Future<bool> checkNameExists(
    String name,
    String tableName,
  ) async {
    List<Map> result = await db.query(
      tableName, // Replace with your table name
      where: 'name = ?',
      whereArgs: [name],
    );

    // If the result is not empty, the name exists
    return result.isNotEmpty;
  }

  Future<void> sendMessageLocally(
      {required String teacherId,
      required String teacherName,
      required String subId,
      required String className,
      required String batch,
      // required String parentId,
      required String subject,
      required String? filePath,
      required String messageId,
      required String message,
      required String? replyId,
      required bool isForward,
      required MsgData? replayMessageData
      // required BuildContext context,
      }) async {
    String portion = className + batch + teacherId + subId;
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
    teacher_name TEXT,
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

    final parentIdString =
        jsonEncode(Get.find<FeedViewController>().setFinalParentList());
    Map<String, dynamic> values = {
      'class': className,
      'batch': batch,
      'subject_id': subId,
      'parent_id': parentIdString,
      'subject': subject,
      // 'student_Id': studentId,
      // 'student_Name': studentName,
      'teacher_id': teacherId,
      'teacher_name': teacherName,
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

    Get.find<FeedViewController>().chatMsgList.value =
        await Get.find<FeedDBController>().getAllMessages(
            studentclass: className, batch: batch, subId: subId);
    final unsentList = await Get.find<FeedDBController>()
        .getUnSentMessage(studentclass: className, subId: subId, batch: batch);

    if (Get.find<FeedViewController>().chatMsgList.isEmpty) {
      Get.find<FeedViewController>().chatMsgList.value = [
        ...unsentList.reversed,
        ...[MsgData()]
      ];
    } else {
      Get.find<FeedViewController>().chatMsgList.value = [
        ...unsentList.reversed,
        ...Get.find<FeedViewController>().chatMsgList
      ];
    }

    // print(
    //     "working -------------- ${await Get.find<DBController>().getUnSentMessage(teacherId: teacherId, subId: subId)}");
    // print(
    //     "working -------------- ${Get.find<MessageController>().messageList}");
  }

  Future<List<MsgData>> getUnSentMessage({
    required String subId,
    required String studentclass,
    required String batch,
  }) async {
    String? teacherId =
        Get.find<UserAuthController>().userData.value.userId ?? "";
    String portion = studentclass + batch + teacherId + subId;
    String messageTableName = "unsentmessage$portion";
    await db.execute('''
  CREATE TABLE IF NOT EXISTS $messageTableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    class TEXT,
    batch TEXT,
    subject_id TEXT,
    parent_id TEXT,
    subject TEXT,
    student_Id TEXT,
    student_Name TEXT,
    teacher_id TEXT,
    teacher_name TEXT,
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
    print("local working ------------------- 2");

    List<MsgData> messageList = [];
    List<Map<String, dynamic>> data = await db.query(messageTableName);

    log("local working feed------------------- $data");

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

      MsgData message = MsgData(
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
        userImage: null,
        incomingReact: [],
      );

      messageList.add(message);
    }
    print("working 2 ------------- ${messageList}");
    return messageList;
  }

  resentUnsentMessage({
    required String teacherId,
    required String subId,
    required BuildContext context,
    required String studentClass,
    required String batch,
  }) async {
    isResentWorking = true;
    print("Resent Working -------------------- ");
    String? teacherId =
        Get.find<UserAuthController>().userData.value.userId ?? "";
    String portion = studentClass + batch + teacherId + subId;
    String messageTableName = "unsentmessage$portion";

    List<Map<String, dynamic>> unsentList = await db.query(messageTableName);

    if (unsentList.isNotEmpty) {
      checkInternetWithOutSnacksbar(
        function: () async {
          context.loaderOverlay.show();
          try {
            await db.rawDelete('DELETE FROM $messageTableName');
            for (var msg in unsentList) {
              await checkInternetWithOutSnacksbar(
                function: () async {
                  print("unsentList ------------- ${unsentList.length}");
                  final replayId = msg['reply_id'].toString().contains("unsent")
                      ? msg['reply_id'].toString().split("/").last
                      : msg['reply_id'];
                  // Get.find<FeedViewController>().replay.value =
                  //     msg['reply_id'].toString().contains("unsent")
                  //         ? msg['reply_id'].toString().split("/").last
                  //         : msg['reply_id'];

                  if (msg['filePath'] != null) {
                    print(
                        "parent list ----------------- ${List<String>.from(jsonDecode(msg['parent_id']))}");
                    await Get.find<FeedViewController>().sendAttach(
                        context: context,
                        classs: msg['class'],
                        batch: msg['batch'],
                        subId: msg['subject_id'],
                        // parentId: Get.find<StudentController>().parentId,
                        sub: msg['subject'],
                        teacherId: msg['teacher_id'],
                        filePath: msg['filePath'],
                        // filePath:
                        //     Get.find<MessageController>().audioPath.value ??
                        //         Get.find<MessageController>().filePath.value,
                        message: msg['message']);
                  } else {
                    print(
                        "parent list ----------------- ${jsonDecode(msg['parent_id'])}");

                    List<String>? parentList =
                        List<String>.from(jsonDecode(msg['parent_id']));
                    SentMsgByTeacherModel sentData = SentMsgByTeacherModel(
                      classs: msg['class'],
                      batch: msg['batch'],
                      subjectId: msg['subject_id'],
                      parents: parentList,
                      subject: msg['subject'],
                      messageFrom: msg['teacher_id'],
                      message: msg['message'],
                      replyId: replayId,
                      fileData: null,
                    );
                    await Get.find<FeedViewController>()
                        .sendAttachMsg(sentMsgData: sentData, context: context);
                    print("refrshh ---------------------2 work");
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
                  }
                },
              );
            }
          } catch (e) {
            print("Resent Working ---------- error ");
            snackBar(
                context: context,
                message: "Something went wrong.",
                color: Colors.red);
          }
          context.loaderOverlay.hide();
        },
      );
    } else {
      print("Nothing working");
    }
    isResentWorking = false;
  }

  Future<void> deleteMessageLocally({
    required String teacherId,
    required String subId,
    required String messageId,
    required String className,
    required String batch,
  }) async {
    String? teacherId =
        Get.find<UserAuthController>().userData.value.userId ?? "";
    String portion = className + batch + teacherId + subId;
    String messageTableName = "unsentmessage$portion";
    await db.delete(
      messageTableName, // Replace with your table name
      where: 'id = ?', // Specify the column for the WHERE clause
      whereArgs: [messageId], // Pass the id value to delete
    );

    // for update List

    Get.find<FeedViewController>().chatMsgList.value =
        await Get.find<FeedDBController>().getAllMessages(
            studentclass: className, batch: batch, subId: subId);
    final unsentList = await Get.find<FeedDBController>()
        .getUnSentMessage(studentclass: className, subId: subId, batch: batch);

    if (Get.find<FeedViewController>().chatMsgList.isEmpty) {
      Get.find<FeedViewController>().chatMsgList.value = [
        ...unsentList.reversed,
        ...[MsgData()]
      ];
    } else {
      Get.find<FeedViewController>().chatMsgList.value = [
        ...unsentList.reversed,
        ...Get.find<FeedViewController>().chatMsgList
      ];
    }
  }

  Future<void> dowloadMediaToDB({
    required String messageId,
    required String url,
    required String type,
  }) async {
    String mediaTableName = "mediatable$type";

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $mediaTableName (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
      filePath TEXT,
      message_id TEXT,
      file_name TEXT UNIQUE,
      file_url TEXT,
      type TEXT
     )
    ''');
    final fileName = url.split("/").last;
    final path = await downloadFile(url, fileName);

    Map<String, dynamic> values = {
      'filePath': path,
      'message_id': messageId,
      'file_name': fileName,
      'file_url': url,
      'type': type
    };

    await db.insert(
      mediaTableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  uiUpdate() async {
    update();
  }

  Future<void> dowloadAudioWaveDataToDB({
    required String messageId,
    required List<double> audioData,
    required String duration,
    required String type,
  }) async {
    String audioTableName = "audiotable$type";

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $audioTableName (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
      message_id TEXT UNIQUE,
      audioData TEXT,
      duration TEXT,
      type TEXT
     )
    ''');

    String jsonString = jsonEncode(audioData);

    Map<String, dynamic> values = {
      'message_id': messageId,
      'audioData': jsonString,
      'duration': duration,
      'type': type
    };

    await db.insert(
      audioTableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getFilePathByFileName({
    required String url,
    required String type,
  }) async {
    String mediaTableName = "mediatable$type";
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $mediaTableName (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
      filePath TEXT,
      message_id TEXT,
      file_name TEXT UNIQUE,
      file_url TEXT,
      type TEXT
     )
    ''');
    // Query the database to get the record with the specified file_name
    final List<Map<String, dynamic>> result = await db.query(
      mediaTableName,
      columns: ['filePath'], // Specify the column to retrieve
      where: 'file_name = ?',
      whereArgs: [url.split("/").last],
    );

    // If a record is found, return the filePath, otherwise return null
    if (result.isNotEmpty) {
      return result.first['filePath'] as String?;
    } else {
      return null; // File not found
    }
  }

  Future<Duration?> getAudiofileDurationData({
    required String messageId,
    required String type,
  }) async {
    String audioTableName = "audiotable$type";
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $audioTableName (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
      message_id TEXT UNIQUE,
      audioData TEXT,
      duration TEXT,
      type TEXT
     )
    ''');

    // Query the database to get the record with the specified file_name
    final List<Map<String, dynamic>> result = await db.query(
      audioTableName,
      columns: ['duration'], // Specify the column to retrieve
      where: 'message_id = ?',
      whereArgs: [messageId],
    );

    // If a record is found, return the filePath, otherwise return null
    if (result.isNotEmpty) {
      Duration duration = parseDuration(result.first['duration'] as String);

      return duration;
    } else {
      return null; // File not found
    }
  }

  Future<List<double>?> getAudiofileWaveData({
    required String messageId,
    required String type,
  }) async {
    String audioTableName = "audiotable$type";

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $audioTableName (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
      message_id TEXT UNIQUE,
      audioData TEXT,
      duration TEXT,
      type TEXT
     )
    ''');

    final data = await db.query(audioTableName);
    // log("data ------------------ $data");

    // Query the database to get the record with the specified file_name
    final List<Map<String, dynamic>> result = await db.query(
      audioTableName,
      columns: ['audioData'], // Specify the column to retrieve
      where: 'message_id = ?',
      whereArgs: [messageId],
    );

    // If a record is found, return the filePath, otherwise return null
    if (result.isNotEmpty) {
      List<dynamic> decoded = jsonDecode(result.first['audioData']);
      List<double> audioData = decoded.map((e) => e as double).toList();
      return audioData;
    } else {
      return null; // File not found
    }
  }

  Future<void> deleteMessageDBLogout() async {
    String dbPath = join(await getDatabasesPath(), 'MessageDB');
    await deleteDatabase(dbPath);
    print("Database deleted successfully");
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      print("Storage permission granted.");
    } else if (status.isDenied) {
      print("Storage permission denied.");
    } else if (status.isPermanentlyDenied) {
      print(
          "Storage permission permanently denied. Please enable it from settings.");
    }
  }

// // Function to download a file from a URL and save it to a specific directory
  Future<String> downloadFile(String url, String fileName) async {
    await requestStoragePermission(); // Ensure storage permission is granted

    try {
      // Define the download directory and create a new folder if it doesn't exist
      // Directory downloadDirectory = Directory('/storage/emulated/0/Download');
      Directory? downloadDirectory = await getApplicationDocumentsDirectory();
      Directory schoolDiaryFolder =
          Directory('${downloadDirectory.path}/School Diary');

      // Create the SchoolDiary folder
      if (!(await schoolDiaryFolder.exists())) {
        await schoolDiaryFolder.create(recursive: true);
      }

      // Set the path where the file will be saved
      String savePath = '${schoolDiaryFolder.path}/$fileName';

      // Download the file from the URL
      var response = await Dio().download(url, savePath);

      // Check if the download was successful
      if (response.statusCode == 200) {
        print('File downloaded to: $savePath');
        // Notify the media scanner to make the file visible in the gallery
        // await _scanFile(savePath);
      } else {
        print('Failed to download file: ${response.statusCode}');
      }

      return savePath; // Return the path of the downloaded file
    } catch (e) {
      print('Failed to download file: $e');
      throw e; // Rethrow the error for further handling
    }
  }

  //-------------------------------------------------------------------------- DB for chat page --------------------------------------------------------------------------//

  Future<void> createParentListTable({
    required String subId,
    required String batch,
    required String studentClass,
  }) async {
    String portion = studentClass + batch + subId;
    String parentTableName = "parentTable$portion";
// Create feed view chatRoomList table

    await db.execute('''
  CREATE TABLE IF NOT EXISTS $parentTableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    username TEXT,
    image TEXT,
    sId TEXT,
    studentId TEXT,
    studentName TEXT,
    gender TEXT,
    isSelected INTEGER
  );
  ''');
  }

  Future<void> insertParentData({
    required String parentTableName,
    required ParentDataSelected parentData,
  }) async {
    await db.insert(
      parentTableName,
      {
        'name': parentData.name,
        'username': parentData.username,
        'image': parentData.image,
        'sId': parentData.sId,
        'studentId': parentData.studentId,
        'studentName': parentData.studentName,
        'gender': parentData.gender,
        'isSelected': parentData.isSelected ? 1 : 0, // Boolean to integer
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Avoid duplicates by replacing
    );
  }

  Future<void> storeParentDatatoDB({
    required String subId,
    required String batch,
    required String studentClass,
    required List<ParentDataSelected> parentList,
  }) async {
    String portion = studentClass + batch + subId;
    String parentTableName = "parentTable$portion";

    await db.rawDelete('DELETE FROM $parentTableName');

    for (ParentDataSelected element in parentList) {
      await insertParentData(
          parentTableName: parentTableName, parentData: element);
    }
  }

  Future<List<ParentDataSelected>> getParentList({
    required String subId,
    required String batch,
    required String studentClass,
  }) async {
    String portion = studentClass + batch + subId;
    String parentTableName = "parentTable$portion";

    await createParentListTable(subId: subId, batch: batch, studentClass: studentClass);

    // Initialize the room list
    List<ParentDataSelected> parentList = [];

    // Query all rows from teacherchatRoomList
    final List<Map<String, dynamic>> parentMaps =
        await db.query(parentTableName);

    // log("parent list local table name ${parentTableName}-------------- ${parentMaps}");

    for (var parent in parentMaps) {
      // Create a ClassTeacherGroup instance
      ParentDataSelected parentData = ParentDataSelected(
          isSelected: parent['isSelected'] == 1,
          gender: parent['gender'],
          image: parent['image'],
          name: parent['name'],
          sId: parent['sId'],
          studentId: parent['studentId'],
          studentName: parent['studentName'],
          username: parent['username']);

      // Add the roomData to the list
      parentList.add(parentData);
    }

    return parentList;
  }
}
