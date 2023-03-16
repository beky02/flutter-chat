import 'package:chat/bloc/firebase_auth_bloc.dart';
import 'package:chat/bloc/firebase_auth_event.dart';
import 'package:chat/bloc/firebase_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: BlocConsumer<FirebaseAuthBloc, FirebaseAuthState>(
          listener: (context, state) {},
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.55,
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                '+251',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        Flexible(
                          child: TextField(
                            controller: _controller,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: 'phone number',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Container(
                      height: size.height * 0.06,
                      child: FlatButton(
                        shape: StadiumBorder(),
                        color: Color.fromARGB(255, 255, 166, 40),
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ChatScreen()));
                          BlocProvider.of<FirebaseAuthBloc>(context)
                              .add(FirbasePhoneAuth(_controller.text));
                        },
                        child: Center(
                            child: Text(
                          "Next",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        )),
                      )),
                  SizedBox(height: size.height * 0.07),
                ],
              ),
            );
          }),
    );
  }
}
