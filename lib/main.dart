import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:aws_project/amplifyconfiguration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;
  bool isSignUpComplete = false;
  bool isSignInComplete = false;

  Amplify amplifyInstance = Amplify();
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    if (!mounted) return;
    try {
      AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
      amplifyInstance.addPlugin(authPlugins: [authPlugin]);
      await amplifyInstance.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
        print(_amplifyConfigured ? "configured" : "not yet");
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> _registerUser(LoginData data) async {
    try {
      SignUpResult res = await Amplify.Auth.signUp(
          username: data.name, password: data.password);
      setState(() {
        isSignUpComplete = res.isSignUpComplete;
        print("sing up " + (isSignUpComplete ? "completed" : "not completed"));
      });
      return "";
    } on AuthError catch (e) {
      return e.toString();
    }
  }

  Future<String> _loginUser(LoginData data) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
          username: data.name, password: data.password);
      setState(() {
        isSignInComplete = res.isSignedIn;
        Alert(
                context: context,
                type: AlertType.success,
                title: "Login success",
                desc: "Good Job")
            .show();
      });
      return "";
    } on AuthError catch (e) {
      Alert(
              context: context,
              type: AlertType.error,
              title: "Login Failed",
              desc: e.toString())
          .show();
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FlutterLogin(
      onSignup: _registerUser,
      onLogin: _loginUser,
      onRecoverPassword: (_) => null,
      title: "AWS Amplify",
    ));
  }
}
