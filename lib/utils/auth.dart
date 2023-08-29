import 'package:ecom_web_flutter/api_repository/api_request.dart';
import 'package:ecom_web_flutter/api_repository/models/models.dart';
import 'package:ecom_web_flutter/injector/injector.dart';
import 'package:ecom_web_flutter/storage/shared_preferences_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>['email', 'profile'];

GoogleSignIn signIn = GoogleSignIn(scopes: scopes);

Future<void> handleSignIn() async {
  try {
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    UserCredential? userCredential;

    try {
      userCredential =
          await FirebaseAuth.instance.signInWithPopup(authProvider);
    } catch (e) {
      print(e);
      // TODO: Handle the error. Maybe inform the user.
      return;
    }

    final User? user = userCredential.user;
    final String? token = await user?.getIdToken();
    print(token);
    if (token != null && user != null) {
      setSharedPref(
          name: user.displayName, token: token, imageUrl: user.photoURL);

      SignInModel model = await signInJWT(token);
      if (model.errors == null || model.errors!.errorCode == null) {
        SharedPreferencesManager pref = locator<SharedPreferencesManager>();
        pref.putString(
            SharedPreferencesManager.keyAccessToken, model.data!.token.token);
      }
    }
  } catch (error) {
    print(error);
    // TODO: Handle unexpected errors. Maybe inform the user.
  }
}

setSharedPref({String? name, String? token, String? imageUrl}) {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  pref.putBool(SharedPreferencesManager.keyAuth, true);
  pref.putString(SharedPreferencesManager.keyName, name ?? '');
  pref.putString(SharedPreferencesManager.keyAccessToken, token ?? '');
  pref.putString(SharedPreferencesManager.keyProfileImage, imageUrl ?? '');
}

Future<bool> isSignIn() async {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  bool _isSignIn = await signIn.isSignedIn();
  if (!_isSignIn) {
    pref.clearAll();
  }
  return _isSignIn;
}

Future<void> silentSignIn() async {
  GoogleSignInAccount? googleSignInAccount;
  User? user;
  bool isAuth = await isSignIn();

  if (!isAuth) {
    try {
      googleSignInAccount = await signIn.signInSilently(reAuthenticate: true);
    } catch (error) {
      print('Error on silent sign-in: $error');
    }

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      user = userCredential.user;
    }

    final String? token = await user?.getIdToken();
    print(token);
    if (token != null && user != null) {
      setSharedPref(
          name: user.displayName, token: token, imageUrl: user.photoURL);

      SignInModel model = await signInJWT(token);
      if (model.errors == null || model.errors!.errorCode == null) {
        SharedPreferencesManager pref = locator<SharedPreferencesManager>();
        pref.putString(
            SharedPreferencesManager.keyAccessToken, model.data!.token.token);
      }
    }
  }
}

Future<bool> handleAuthorizeScopes() async {
  final bool isAuthorized = await signIn.requestScopes(scopes);
  return isAuthorized;
}

Future<void> handleSignOut() async {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  signIn.disconnect();
  FirebaseAuth.instance.signOut();
  pref.clearAll();
  pref.putBool(SharedPreferencesManager.keyAuth, false);
}

Future<SignInModel> signInJWT(String token) async {
  Map<String, dynamic> body = {'accessToken': token};
  var response = await apiRequest<SignInModel, void>('/auth/signin',
      body: body, method: HttpMethod.POST);
  return response;
}
