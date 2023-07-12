import 'dart:js_interop';

import 'package:ecom_web_flutter/injector/injector.dart';
import 'package:ecom_web_flutter/storage/shared_preferences_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn signIn = GoogleSignIn(
  clientId:
      '118312898892-96kf4vbgv6gmjm2fn990paedtg5lanij.apps.googleusercontent.com',
  scopes: scopes,
);

Future<void> handleSignIn() async {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  try {
    GoogleSignInAccount? _account = await signIn.signIn();
    if (!_account.isNull) {
      pref.putBool(SharedPreferencesManager.keyAuth, true);
      pref.putString(
          SharedPreferencesManager.keyName, _account!.displayName ?? '');
      pref.putString(SharedPreferencesManager.keyAccessToken,
          _account.serverAuthCode ?? '');
      pref.putString(
          SharedPreferencesManager.keyProfileImage, _account.photoUrl ?? '');
    }
  } catch (error) {
    print(error);
  }
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
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  try {
    bool isLogin = await isSignIn();
    if (!isLogin) {
      GoogleSignInAccount? _account =
          await signIn.signInSilently(reAuthenticate: true);
      if (!_account.isNull) {
        pref.putBool(SharedPreferencesManager.keyAuth, true);
        pref.putString(
            SharedPreferencesManager.keyName, _account!.displayName ?? '');
        pref.putString(
            SharedPreferencesManager.keyProfileImage, _account.photoUrl ?? '');
        pref.putString(SharedPreferencesManager.keyAccessToken,
            _account.serverAuthCode ?? '');
      }
    }
  } catch (e) {
    print(e);
  }
}

Future<bool> handleAuthorizeScopes() async {
  final bool isAuthorized = await signIn.requestScopes(scopes);
  return isAuthorized;
}

Future<void> handleSignOut() async {
  SharedPreferencesManager pref = locator<SharedPreferencesManager>();
  signIn.disconnect();
  pref.clearAll();
}
