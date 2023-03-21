import 'package:create_reminder/data/sql_helper.dart';
import 'package:create_reminder/screens/home_screen.dart';
import 'package:create_reminder/screens/register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../utils/validator.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  GlobalKey<FormState> loginformGlobalKey = GlobalKey<FormState>();

  static List<Map<String, dynamic>> _listofUsers = [];
  FToast? fToast;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    getAllUsers();
    _passwordVisible = false;
    fToast = FToast();
    fToast?.init(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

// get list of user who register already
  void getAllUsers() async {
    final data = await SQLHelper.getLoginData();

    setState(() {
      _listofUsers = data;
    });
  }

  showCustomToast() {
    _passwordController.clear();
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent[700],
      ),
      child: const Text(
        "Email Id or Password may be incorrect",
        style: TextStyle(color: Colors.white),
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }

  displayCustomToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green[600],
      ),
      child: const Text(
        "Login Successfully",
        style: TextStyle(color: Colors.white),
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfffefefd),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode focusScopeNode = FocusScope.of(context);
          if (!focusScopeNode.hasPrimaryFocus) {
            focusScopeNode.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  child: Image.asset(
                    "assets/images/loginimage.png",
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: double.infinity,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Form(
                              key: loginformGlobalKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  loginLabel(),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  //email

                                  Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      style:
                                          TextStyle(color: Color(0xff000000)),
                                      cursorColor: Color(0xff000000),
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff000000)),
                                          borderRadius: BorderRadius.vertical(),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff000000)),
                                          borderRadius: BorderRadius.vertical(),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 12),
                                        hintText: 'Email',
                                        hintStyle: TextStyle(
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                      validator: emailValidator,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),

                                  //password

                                  Container(
                                    child: TextFormField(
                                      style:
                                          TextStyle(color: Color(0xff000000)),
                                      cursorColor: Color(0xff000000),
                                      controller: _passwordController,
                                      obscureText: !_passwordVisible,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.vertical(),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff000000)),
                                          borderRadius: BorderRadius.vertical(),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 12),
                                        hintText: 'Password',
                                        hintStyle: TextStyle(
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.security,
                                          color: Color(0xff000000),
                                        ),
                                        suffixIcon: InkWell(
                                            child: Icon(
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Color(0xff000000),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            }),
                                      ),
                                      validator: passwordvalidator,
                                    ),
                                  ),
                                  SizedBox(height: 14),

                                  // login button

                                  SizedBox(
                                      width: double.infinity,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color(0xfff007dfe)),
                                          child: TextButton(
                                            onPressed: () async {
                                              if (loginformGlobalKey
                                                  .currentState!
                                                  .validate()) {
                                                int? tempid;
                                                bool islog = false;
                                                for (int i = 0;
                                                    i < _listofUsers.length;
                                                    i++) {
                                                  if (_emailController.text ==
                                                          _listofUsers[i][
                                                              'login_uemail'] &&
                                                      _passwordController
                                                              .text ==
                                                          _listofUsers[i][
                                                              'login_upassword']) {
                                                    islog = true;
                                                    tempid = i;
                                                  }
                                                }
                                                ;
                                                if (islog == true) {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  await prefs.setBool(
                                                      'isLoggedIn', true);

                                                  await prefs.setInt(
                                                      'userprefs',
                                                      _listofUsers[tempid!]
                                                          ['login_uid']);

                                                  displayCustomToast();
                                                  _navigatetoHome(
                                                      context,
                                                      _listofUsers[tempid]
                                                          ['login_uid']);
                                                } else {
                                                  showCustomToast();
                                                }
                                              }
                                            },
                                            child: Text(
                                              "LogIn",
                                              style: TextStyle(
                                                color: Color(0xfffefefd),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ))),
                                  SizedBox(height: 14),

                                  //login to Register

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Not a member?',
                                          style: TextStyle(
                                              color: Color(0xff000000))),
                                      SizedBox(width: 3),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Register()));
                                        },
                                        child: const Text(
                                          'Register now',
                                          style: TextStyle(
                                              color: Color(0xfff007dfe),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigatetoHome(BuildContext context, index) async {
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Home(
                id: index,
              )),
    );
  }
}

Widget loginLabel() {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(
      "Log In",
      style: TextStyle(
        color: Color(0xff000000),
        fontWeight: FontWeight.w900,
        fontSize: 30,
      ),
    ),
  ]);
}
