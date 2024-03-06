import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cocofapp/shared/components/components.dart';
import 'package:cocofapp/shared/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var username = TextEditingController();

  var test = TextEditingController();

  String password = '';
  var pass = TextEditingController();
  bool isPasswordVisible = true;
  
  final ref = FirebaseDatabase.instance.ref();
  // CollectionReference storeCollection = Firestore.instance.collection('cocofapp');


  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    username.addListener(() => setState(() {}));
  }

  bool showSpinner = false;
  late String errorMessage;

  @override
  Widget build(BuildContext context) {
    // late DateTime now;
    // now = DateTime.now();
    // ref.child("coir_in").update({
    //   now.toString().substring(0,19) : {
    //     "by": true,
    //     "date": now.toString(),
    //     "payment": 1377,
    //     "suply": "P Nimal",
    //     "weight": 140,
    //   }
    // });
    // ref.child("account").child("cash").set(50);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CoCoFApp',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              ' ',
              style: TextStyle(
                fontSize: 27.0,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Web',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset('assets/coir.png', scale: 1.5),
                  ),
                  const Text(
                    'Log in',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 55.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              /*username*/ textField(
                keyboardType: TextInputType.emailAddress,
                controller: username,
                hinttext: 'User Name',
                width: 400,
                suffixIcon: username.text.isEmpty
                    ? Container(width: 0)
                    : IconButton(
                        icon: const Icon(Icons.close, size: 20.0, color: Colors.black),
                        onPressed: () => username.clear(),
                      ),
              ),
              const SizedBox(height: 10),
              /*password*/ textField(
                keyboardType: TextInputType.emailAddress,
                controller: pass,
                hinttext: 'Password',
                isPassword: true,
                width: 400,
                suffixIcon: pass.text.isEmpty
                    ? Container(width: 0)
                    : IconButton(
                        icon: isPasswordVisible
                            ? const Icon(Icons.visibility_off, size: 20.0, color: Colors.black)
                            : const Icon(Icons.visibility, size: 20.0, color: Colors.black),
                        onPressed: () => setState(
                          () => isPasswordVisible = !isPasswordVisible,
                        ),
                      ),
                onChange: (value) => setState(() => password = value),
                isPasswordVisible: isPasswordVisible,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     TextButton(
              //       child: const Text(
              //         'Forgot password?',
              //         style: TextStyle(color: Colors.white),
              //       ),
              //       onPressed: () {},
              //     ),
              //   ],
              // ),

              const SizedBox(height: 20),
              /*login*/ commonButton(
                text: 'Log In',
                width: 350,
                function: () async {
                  // final account = await storeCollection.document('account').get();
                  //
                  // print(account['cash']);
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      if (username.text == "Admin1" && password == "qwer1234") {
                        globals.isAdmin = true;
                        Navigator.pushNamed(context, 'menu_screen');
                      }
                      else if (username.text == "Editor" && password == "editor12") {
                        globals.isAdmin = false;
                        Navigator.pushNamed(context, 'menu_screen');
                      }
                      else{
                        throw("Username or Password is Incorrect");
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                      setState(() {
                        errorMessage = e.toString();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
                fontsize: 25.0,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 500),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
