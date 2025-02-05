import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_dto.dart';
import '../utils/text_strings.dart';

class UserDatabaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserDTO> addUserToDatabase(UserDTO userDTO) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: userDTO.email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        throw Exception(emailAlreadyUsedErrorMessage);
      } else {
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
                email: userDTO.email, password: userDTO.password);
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userDTO.toJson());
        userDTO.id = userCredential.user?.uid ?? '';
        return userDTO;
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserDTO> logInUser(UserDTO userDTO) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: userDTO.email,
        password: userDTO.password,
      );
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (userSnapshot.exists && userSnapshot.data() != null) {
        return UserDTO.fromJson(
            userSnapshot.data() as Map<String, dynamic>, userSnapshot.id);
      } else {
        throw Exception(userNotFoundErrorMessage);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == userNotFound) {
        throw Exception(userNotFoundErrorMessage);
      } else if (e.code == wrongPassword) {
        throw Exception(wrongPasswordErrorMessage);
      } else {
        throw Exception(tryLaterErrorMessage);
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> updateUser(UserDTO userDTO) async {
    try {
      await _firestore
          .collection('users')
          .doc(userDTO.id)
          .update({'favorites': userDTO.favorites});
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserDTO> getUserProfile(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        Map<String, dynamic>? data =
            userSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          return UserDTO.fromJson(data, userSnapshot.id);
        }
      }
      throw Exception(noUserFoundErrorMessage);
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> updateUserProfile(UserDTO userDTO) async {
    try {
      DocumentReference docRef = _firestore.collection('users').doc(userDTO.id);
      await docRef.set(userDTO.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}
