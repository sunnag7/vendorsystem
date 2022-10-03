
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled/pages/emp_dash.dart';
import 'package:untitled/pages/inspector_dash.dart';
import '../common/theme_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:validators/validators.dart';

import 'admin_dash.dart';
import 'forgot_password_page.dart';
import 'profile_page.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}): super(key:key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  double _headerHeight = 250;
  //Key _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _storage = const FlutterSecureStorage();

  final TextEditingController _usernameController =
  TextEditingController(text: "");
  final TextEditingController _passwordController =
  TextEditingController(text: "");
  final TextEditingController _loginController =
  TextEditingController(text: "");
  bool passwordHidden = true;
  final bool _savePassword = true;

  // Read values
  Future<void> _readFromStorage() async {
    _usernameController.text = await _storage.read(key: "KEY_USERNAME") ?? '';
    _passwordController.text = await _storage.read(key: "KEY_PASSWORD") ?? '';
    _loginController.text = await _storage.read(key: "LOGIN_STATUS") ?? '';
    if(_loginController.text=="true"){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDash()));
    }
}

  _onFormSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_savePassword) {

        // Write values
        await _storage.write(key: "KEY_USERNAME", value: _usernameController.text);
        await _storage.write(key: "KEY_PASSWORD", value: _passwordController.text);
        if(_usernameController.text=="admin"){
          await _storage.write(key: "LOGIN_STATUS", value: "true");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDash()));
        }
        else if(_usernameController.text=="employee"){
          await _storage.write(key: "LOGIN_STATUS", value: "true");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmployeeDash()));
        }
        else if(_usernameController.text=="inspector"){
          await _storage.write(key: "LOGIN_STATUS", value: "true");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InspectorDash()));
        }
        else{
          await _storage.write(key: "LOGIN_STATUS", value: "false");
          var snackbar = const SnackBar(
            content: Text('Login Failed'),
          );
          //scaffoldKey.currentState.showSnackBar(snackbar);
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          //showToast;
        }

      }
    }
  }

  _onForgotPassword() {}

  _onSignUp() {}

  @override
  void initState() {
    super.initState();
    _readFromStorage();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container( 
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                child: Column(
                  children: [
                   const Text(
                      'Hello',
                      style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                   const Text(
                      'Signin into your account',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                        child: Column(
                          children: [
                            TextField(
                              decoration: ThemeHelper().textInputDecoration('User Name', 'Enter your user name'),

                              controller: _usernameController,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 30.0),
                            Container(
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextField(
                                obscureText: true,
                                decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                                controller: _passwordController,
                                 enableSuggestions: false,
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10,0,10,20),
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
                                },
                                child: const Text( "Forgot your password?", style: TextStyle( color: Colors.grey, ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                 onPressed: _onFormSubmit,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text('Sign In'.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                ),
                              /*  onPressed: (){
                                  //After successful login we will redirect to profile page. Let's create profile page now

                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                                },*/

                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10,20,10,20),
                              //child: Text('Don\'t have an account? Create'),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(text: "Don\'t have an account? "),
                                    TextSpan(
                                      text: 'Create',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                                        },
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                    ),
                                  ]
                                )
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );

  }
}