import 'dart:developer';

import 'package:chat_app/view/controller/sign_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../modal/user_modal.dart';
import '../firebase_database/user_services.dart';

class GoogleFirebaseServices {
  SignController sign = Get.find();
  static GoogleFirebaseServices googleFirebaseServices =
      GoogleFirebaseServices._();

  GoogleFirebaseServices._();

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn.instance;

  Future<void> createEmailAndPassword(String? email, String? pwd) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email!, password: pwd!);
      Get.toNamed('/signin');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> compareEmailAndPwd(String? email, String? pwd) async {
    try {
      await auth.signInWithEmailAndPassword(email: email!, password: pwd!);
      Map userModal = {
        'username': sign.txtUser.text,
        'email': sign.txtCreateMail.text,
      };

      UserModal user = UserModal(userModal);
      UserService.userSarvice.addUser(user);
      currentUser();
      UserService.userSarvice.updateUserToken();

      Get.toNamed('/home');
    } on FirebaseAuthException catch (e) {
      log(e.code);
      if (e.code == 'user-not-found' || e.code == "invalid-email") {
        Fluttertoast.showToast(
            msg: "No User Found for that Email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        Fluttertoast.showToast(
            msg: "Wrong Password Provided by User",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'channel-error') {
        Fluttertoast.showToast(
            msg: "Enter the email and password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  void emailLogout() {
    try {
      googleSignIn.signOut();
      auth.signOut();
      currentUser();
      sign.phone.value = '';
      Get.offAndToNamed('/otp');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      await googleSignIn.initialize(
        serverClientId:
            '338011390486-69feosg3l2ie2l83doekjse1b46oh095.apps.googleusercontent.com',
      );

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.authenticate();

      if (googleSignInAccount == null) {
        return ""; // User cancelled
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        // Also include this
      );

      await auth.signInWithCredential(authCredential);
      currentUser();

      Map userModal = {
        'username': auth.currentUser!.displayName,
        'email': auth.currentUser!.email,
        'photoUrl': auth.currentUser!.photoURL,
      };

      UserModal user = UserModal(userModal);
      UserService.userSarvice.addUser(user);
      UserService.userSarvice.updateUserToken();

      return "Success";
    } catch (e, stackTrace) {
      debugPrint("error ::${e.toString()} \n stackTrace :: $stackTrace");
      return "";
    }
  }

  User? currentUser() {
    User? user = auth.currentUser;
    return user;
  }

  Future<void> mobileUser(String number, String countryCode) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: countryCode + number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await auth.signInWithCredential(credential);
            Fluttertoast.showToast(
                msg: 'Phone number automatically verified and user signed in.');
            Get.offAllNamed('/home');
          } catch (e) {
            Fluttertoast.showToast(msg: 'Automatic verification failed.');
            log(e.toString());
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            Fluttertoast.showToast(
                msg: 'The provided phone number is not valid.');
          } else if (e.code == 'too-many-requests') {
            Fluttertoast.showToast(
                msg: 'Too many requests. Please try again later.');
          } else if (e.code == 'quota-exceeded') {
            Fluttertoast.showToast(
                msg: 'SMS quota exceeded. Enable billing in Firebase.');
          } else {
            Fluttertoast.showToast(
                msg: 'Phone verification failed. Try again later.');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          sign.verificationId.value = verificationId;
          Fluttertoast.showToast(msg: 'OTP sent successfully.');
          Get.toNamed('/otpAdd');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Fluttertoast.showToast(
              msg: 'Code retrieval timeout. Please try again.');
        },
      );
    } catch (e) {}
  }

  Future<void> mobileVarifaction(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: sign.verificationId.value, smsCode: smsCode);
      await auth.signInWithCredential(credential);
      currentUser();
      Map userModal = {
        'username': sign.txtUserName.text,
        'email': auth.currentUser!.phoneNumber,
      };
      UserModal user = UserModal(userModal);
      UserService.userSarvice.addUser(user);
      UserService.userSarvice.updateUserToken();

      Get.offAndToNamed('/home');
    } catch (e) {
      log(e.toString());
    }
  }
}

// class GoogleFirebaseServices {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   late GoogleSignIn googleSignIn;

//   // Initialize Google Sign-In
//   Future<void> initializeGoogleSignIn() async {
//     googleSignIn = GoogleSignIn.instance;

//     await googleSignIn.initialize(
//       serverClientId:
//           '338011390486-69feosg3l2ie2l83doekjse1b46oh095.apps.googleusercontent.com',
//     );

//     // Listen to authentication events
//     googleSignIn.authenticationEvents
//         .listen(_handleAuthenticationEvent)
//         .onError(_handleAuthenticationError);

//     // Attempt lightweight authentication (silent sign-in)
//     googleSignIn.attemptLightweightAuthentication();
//   }

//   // Handle authentication events
//   void _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) {
//     debugPrint('Google Sign-In Event: ${event.type}');

//     switch (event.type) {
//       case GoogleSignInAuthenticationEventType.signedIn:
//         _handleSignedIn(event.account);
//         break;
//       case GoogleSignInAuthenticationEventType.signedOut:
//         _handleSignedOut();
//         break;
//       case GoogleSignInAuthenticationEventType.failed:
//         _handleAuthenticationFailed(event.exception);
//         break;
//     }
//   }

//   // Handle authentication errors
//   void _handleAuthenticationError(Object error, StackTrace stackTrace) {
//     debugPrint('Google Sign-In Error: $error');
//     debugPrint('Stack Trace: $stackTrace');

//     // You can show user-friendly error messages here
//     if (error is GoogleSignInException) {
//       switch (error.code) {
//         case GoogleSignInExceptionCode.networkError:
//           _showError('Network error. Please check your internet connection.');
//           break;
//         case GoogleSignInExceptionCode.canceled:
//           _showError('Sign in was cancelled.');
//           break;
//         case GoogleSignInExceptionCode.signInFailed:
//           _showError('Sign in failed. Please try again.');
//           break;
//         case GoogleSignInExceptionCode.clientConfigurationError:
//           _showError('Configuration error. Please contact support.');
//           break;
//         default:
//           _showError('An unexpected error occurred during sign in.');
//       }
//     } else {
//       _showError('An unexpected error occurred during sign in.');
//     }
//   }

//   // Handle successful sign-in
//   void _handleSignedIn(GoogleSignInAccount? account) async {
//     if (account == null) {
//       debugPrint('Sign-in account is null');
//       return;
//     }

//     try {
//       debugPrint('User signed in: ${account.email}');

//       // Get authentication details
//       final GoogleSignInAuthentication googleAuth =
//           await account.authentication;

//       // Create Firebase credential
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase
//       final UserCredential userCredential =
//           await auth.signInWithCredential(credential);

//       if (userCredential.user != null) {
//         debugPrint(
//             'Firebase sign-in successful: ${userCredential.user!.email}');

//         // Create user model and save to your service
//         Map userModal = {
//           'username': userCredential.user!.displayName ?? account.displayName,
//           'email': userCredential.user!.email ?? account.email,
//           'photoUrl': userCredential.user!.photoURL ?? account.photoUrl,
//         };

//         UserModal user = UserModal(userModal);
//         UserService.userSarvice.addUser(user);
//         UserService.userSarvice.updateUserToken();

//         // Navigate to main app or update UI state
//         _onSignInSuccess();
//       }
//     } catch (e, stackTrace) {
//       debugPrint('Error during Firebase sign-in: $e');
//       debugPrint('Stack trace: $stackTrace');
//       _handleAuthenticationError(e, stackTrace);
//     }
//   }

//   // Handle sign-out
//   void _handleSignedOut() {
//     debugPrint('User signed out');

//     // Sign out from Firebase as well
//     auth.signOut();

//     // Clear user data or navigate to login screen
//     _onSignOutSuccess();
//   }

//   // Handle authentication failure
//   void _handleAuthenticationFailed(GoogleSignInException? exception) {
//     debugPrint('Authentication failed: ${exception?.toString()}');

//     if (exception != null) {
//       _handleAuthenticationError(exception, StackTrace.current);
//     }
//   }

//   // Show error message to user (implement based on your UI framework)
//   void _showError(String message) {
//     debugPrint('Error Message: $message');

//     // Example implementations:
//     // For Flutter with ScaffoldMessenger:
//     // ScaffoldMessenger.of(context).showSnackBar(
//     //   SnackBar(content: Text(message)),
//     // );

//     // For custom error handling:
//     // ErrorService.showError(message);

//     // For state management (Bloc, Provider, etc.):
//     // authBloc.add(AuthError(message));
//   }

//   // Called when sign-in is successful
//   void _onSignInSuccess() {
//     debugPrint('Sign-in completed successfully');

//     // Navigate to home screen or update app state
//     // Example:
//     // Navigator.of(context).pushReplacementNamed('/home');
//     // or update your state management
//   }

//   // Called when sign-out is successful
//   void _onSignOutSuccess() {
//     debugPrint('Sign-out completed successfully');

//     // Navigate to login screen or update app state
//     // Example:
//     // Navigator.of(context).pushReplacementNamed('/login');
//   }

//   // Manual sign-in method (for button press)
//   Future<String> signInWithGoogle() async {
//     try {
//       if (googleSignIn.supportsAuthenticate()) {
//         await googleSignIn.authenticate();
//         // The _handleAuthenticationEvent will handle the rest
//         return "Authentication initiated";
//       } else {
//         // Fallback for platforms that don't support authenticate()
//         final GoogleSignInAccount? account = await googleSignIn.authenticate();
//         if (account != null) {
//           _handleSignedIn(account);
//           return "Success";
//         }
//         return "Sign-in cancelled";
//       }
//     } catch (e, stackTrace) {
//       debugPrint("Manual sign-in error: $e");
//       _handleAuthenticationError(e, stackTrace);
//       return "Error occurred";
//     }
//   }

//   // Manual sign-out method
//   Future<void> signOut() async {
//     try {
//       await googleSignIn.signOut();
//       // The _handleAuthenticationEvent will handle the rest
//     } catch (e, stackTrace) {
//       debugPrint("Sign-out error: $e");
//       _handleAuthenticationError(e, stackTrace);
//     }
//   }

//   // Check current authentication state
//   bool get isSignedIn => googleSignIn.currentUser != null;

//   GoogleSignInAccount? get currentUser => googleSignIn.currentUser;
// }
