import 'package:chat/bloc/firebase_auth_bloc.dart';
import 'package:chat/bloc/firebase_auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({Key key, @required this.verificationId}) : super(key: key);
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.3),
          Text(
            'We sent you an SMS code',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: _controller,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: 'verification code',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
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
                      .add(FirbaseSmsCodeAuth(widget.verificationId, _controller.text));
                },
                child: Center(
                    child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                )),
              )),
        ],
      ),
    );
  }
}
