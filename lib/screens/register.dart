import 'package:create_reminder/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import '../data/sql_helper.dart';
import '../utils/validator.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Database? _database;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var size, height, width;
  GlobalKey<FormState> registrationformGlobalKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _listofUsers = [];

  bool _passwordVisible = false;
  bool _confirmpassword = false;

  FToast? fToast;

  @override
  void initState() {
    _passwordVisible = false;
    _confirmpassword = false;
    getAllUsers();
    fToast = FToast();
    fToast?.init(context);
  }

  void getAllUsers() async {
    final data = await SQLHelper.getLoginData();
    print('$data');
    setState(() {
      _listofUsers = data;
      print('Users List $_listofUsers');
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  showCustomToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent[700],
      ),
      child: const Text(
        "User already Exist",
        style: TextStyle(color: Colors.white),
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }

  showErrorToast(Color errorcolor, String errormessege) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: errorcolor,
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_sharp,
            color: Colors.white,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            errormessege,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }

  registationCustomToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green[600],
      ),
      child: const Text(
        "Register Successfully",
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
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: Image.asset(
                    "assets/images/loginimage.png",
                    width: double.infinity,
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Form(
                              key: registrationformGlobalKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  registerLabel(),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  //email

                                  Container(
                                    child: TextFormField(
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
                                    style: TextStyle(color: Color(0xff000000)),
                                    enableInteractiveSelection: false,
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
                                            })),
                                    validator: passwordvalidator,
                                  )),
                                  SizedBox(height: 14),

                                  //confirm password

                                  Container(
                                    child: TextFormField(
                                      validator: ((value) {
                                        if (value !=
                                            _passwordController.value.text) {
                                          return "Password do not match";
                                        }
                                        return null;
                                      }),
                                      style:
                                          TextStyle(color: Color(0xff000000)),
                                      cursorColor: Color(0xff000000),
                                      controller: _confirmPasswordController,
                                      enableInteractiveSelection: false,
                                      obscureText: !_confirmpassword,
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
                                        hintText: 'Confirm Password',
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
                                              _confirmpassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Color(0xff000000),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _confirmpassword =
                                                    !_confirmpassword;
                                              });
                                            }),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 14),

                                  // Register button

                                  SizedBox(
                                      width: double.infinity,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color(0xfff007dfe)),
                                          child: TextButton(
                                              onPressed: () {
                                                if (registrationformGlobalKey
                                                    .currentState!
                                                    .validate()) {
                                                  int? tempid;
                                                  bool olduser = false;

                                                  for (int i = 0;
                                                      i < _listofUsers.length;
                                                      i++) {
                                                    if (_emailController.text !=
                                                        _listofUsers[i]
                                                            ['login_uemail']) {
                                                      olduser = false;
                                                    } else {
                                                      olduser = true;
                                                      print(olduser);
                                                      i = _listofUsers.length;
                                                    }
                                                  }
                                                  if (olduser == false) {
                                                    if (_passwordController
                                                            .text ==
                                                        _confirmPasswordController
                                                            .text) {
                                                      SQLHelper
                                                          .addIntoTableLogin(
                                                              _emailController
                                                                  .text
                                                                  .toString(),
                                                              _passwordController
                                                                  .text
                                                                  .toString());
                                                      registationCustomToast();
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Login()));
                                                    }
                                                  } else {
                                                    showCustomToast();
                                                  }
                                                }
                                              },
                                              child: Text("Register",
                                                  style: TextStyle(
                                                    color: Color(0xfffefefd),
                                                    fontSize: 13,
                                                  ))))),
                                  SizedBox(height: 14),

                                  // Regster to Login

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account?',
                                        style:
                                            TextStyle(color: Color(0xff000000)),
                                      ),
                                      SizedBox(width: 3),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()));
                                        },
                                        child: Text(
                                          'Login now',
                                          style: TextStyle(
                                            color: Color(0xfff007dfe),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
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

  Widget registerLabel() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Register",
        style: TextStyle(
          color: Color(0xff000000),
          fontWeight: FontWeight.w900,
          fontSize: 30,
        ),
      ),
    ]);
  }
}
