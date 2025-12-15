// services/auth_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:glow_up/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      if (googleUser.authentication.idToken == null) {
        return {'user': null, 'isNewUser': false};
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;
      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      if (user != null && isNewUser) {
        await _createMinimalUserDocument(user);
      }

      return {'user': user, 'isNewUser': isNewUser};
    } catch (e) {
      print('Google Sign-In Error: $e');
      return {'user': null, 'isNewUser': false};
    }
  }

  Future<Map<String, dynamic>> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        oauthCredential,
      );
      final User? user = userCredential.user;
      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      if (user != null && isNewUser) {
        await _createMinimalUserDocument(user);
      }

      return {'user': user, 'isNewUser': isNewUser};
    } catch (e) {
      print('Apple Sign-In Error: $e');
      return {'user': null, 'isNewUser': false};
    }
  }

  Future<void> _createMinimalUserDocument(User firebaseUser) async {
    final userRef = _db.collection('users').doc(firebaseUser.uid);

    final UserModel minimalUser = UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName,
      email: firebaseUser.email,
      profilePictureUrl: firebaseUser.photoURL,
      userName: firebaseUser.displayName?.split(' ').first.toLowerCase() ?? '',
      dateCreated: DateTime.now(),
      lastActiveDate: DateTime.now(),
      streakCount: 0,
      votes: 0,
      battles: 0,
      winDates: [],
      isProfilePrivate: false,
      friendUids: [],
      pendingRequestUids: [],
      sentRequestUids: [],
      blockedUids: [],
    );

    await userRef.set(minimalUser.toJson(), SetOptions(merge: true));
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  bool get isLoggedIn => _auth.currentUser != null;
  User? get currentUser => _auth.currentUser;
  String? get currentUid => _auth.currentUser?.uid;
}
