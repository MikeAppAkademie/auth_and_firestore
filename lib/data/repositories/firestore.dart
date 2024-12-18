import 'package:auth_and_firestore/data/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore;

  FirestoreRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Prüfen, ob ein Benutzer-Dokument existiert
  Future<bool> doesUserDocExist(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists;
  }

  // Erstelle ein neues Benutzer-Dokument
  Future<void> createUserDoc(String userId, User user) async {
    await _firestore.collection('users').doc(userId).set(user.toMap());
  }

  // Lade Benutzerdaten und konvertiere sie in ein User
  Future<User?> getUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists && doc.data() != null) {
      return User.fromMap(doc.id, doc.data()!);
    }
    return null;
  }
}
