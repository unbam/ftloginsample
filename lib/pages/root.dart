import 'package:flutter/material.dart';
import 'package:ftloginsample/services/auth.dart';
import 'package:ftloginsample/pages/home.dart';
import 'package:ftloginsample/pages/sign_in.dart';
import 'package:ftloginsample/pages/sign_up.dart';

class Root extends StatefulWidget {
  Root({this.auth});

  // Auth
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootState();
}

enum AuthStatus {
  NOT_DETERMINED, //
  NOT_SIGNED_IN,  // 未サインイン
  SIGNED_IN,      // サインイン済み
  SIGNED_UP,      // サインアップ済(登録)
}

class _RootState extends State<Root> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  /*
  初期処理
   */
  @override
  void initState() {
    super.initState();

    // Firebase Auth
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }

        authStatus = user?.uid == null ? AuthStatus.NOT_SIGNED_IN : AuthStatus.SIGNED_IN;
      });
    });
  }

  /*
  サインアップ
   */
  void _onSignUp() {
    setState(() {
      authStatus = AuthStatus.SIGNED_UP;
    });
  }

  /*
  サインイン
   */
  void _onSignIn() {
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.SIGNED_IN;
    });
  }

  /*
  サインアウト
   */
  void _onSignOut() {
    setState(() {
      authStatus = AuthStatus.NOT_SIGNED_IN;
      _userId = "";
    });
  }

  /*
  待機画面
   */
  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      // 待機
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      // サインイン画面
      case AuthStatus.NOT_SIGNED_IN:
//        return new LoginSignUpPage(
//          auth: widget.auth,
//          onSignIn: _onSignIn,
//        );
        return new SignIn(auth: widget.auth, onSignIn: _onSignIn, onSignUp: _onSignUp);
        break;
      // ホーム画面
      case AuthStatus.SIGNED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new Home(
            userId: _userId,
            auth: widget.auth,
            onSignOut: _onSignOut,
          );
        }
        else {
          // TODO: ERROR
          return _buildWaitingScreen();
        }
        break;
      // サインアップ画面
      case AuthStatus.SIGNED_UP:
        return new SignUp(auth: widget.auth, onSignOut: _onSignOut);
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
