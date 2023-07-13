import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazali_chat/services/models.dart';
import 'package:gazali_chat/typedefs.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Map<String, dynamic> _getDocumentsMapData(
      QueryDocumentSnapshot<JsonType> s) {
    var result = s.data();
    result["id"] = s.id;
    return result;
  }

  static Future<List<Chat>> getUserChats(String userId) async {
    var ref1 = _db.collection("chats").where("user1.id", isEqualTo: userId);
    var ref2 = _db.collection("chats").where("user2.id", isEqualTo: userId);

    var snapshot1 = await ref1.get();
    var snapshot2 = await ref2.get();

    List<JsonType> data = [];
    Iterable<JsonType> data1 = snapshot1.docs.map(_getDocumentsMapData);
    Iterable<JsonType> data2 = snapshot2.docs.map(_getDocumentsMapData);

    data.addAll(data1);
    data.addAll(data2);

    return data.map((d) => Chat.fromJson(d)).toList();
  }

  static addUserDocument({
    required String userId,
    required String name,
    required String email,
  }) async {
    var ref = _db.collection("users");

    ref.doc(userId).set({
      "name": name,
      "email": email,
      "users_chats": [],
    });
  }

  static Future<void> editNameUserDocument({required id, required newName}) {
    var ref = _db.collection("users").doc(id);

    return ref.update({
      "name": newName,
    });
  }

  /// this method return users with chats details
  ///
  /// while in chats collection the users only has id, name and email
  static Future<List<UserWithChats>> getAllUsersDocuments() async {
    var ref = _db.collection("users");

    var snapshot = await ref.get();

    var data = snapshot.docs.map(_getDocumentsMapData);

    return data.map((user) => UserWithChats.fromJson(user)).toList();
  }

  static addChatDocument({required User user1, required User user2}) async {
    // append user2 to chats of user1
    await _db.collection("users").doc(user1.id).update({
      "users_chats": FieldValue.arrayUnion([user2.id]),
    });

    // append user1 to chats of user2
    await _db.collection("users").doc(user2.id).update({
      "users_chats": FieldValue.arrayUnion([user1.id]),
    });

    // create new chat document
    return _db.collection("chats").add({
      "user1": user1.toJson(),
      "user2": user2.toJson(),
    });
  }

  static addMessageDocument({
    required String chatId,
    required String senderId,
    required String text,
  }) {
    return _db.collection("{messages}-$chatId").add({
      "sender_id": senderId,
      "text": text,
      "created_at": Timestamp.now(),
    });
  }

  static Stream<QuerySnapshot<JsonType>> messageCollectionStream(
      String chatId) {
    return _db
        .collection("{messages}-$chatId")
        .orderBy("created_at", descending: false)
        .snapshots();
  }
}
