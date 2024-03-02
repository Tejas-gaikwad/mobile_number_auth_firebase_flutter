import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../all_items/bloc/items_bloc.dart';
import '../../all_items/view/all_items.dart';
import '../../constants/colors.dart';

class OtpPageScreen extends StatefulWidget {
  final String vid;
  const OtpPageScreen({super.key, required this.vid});

  @override
  State<OtpPageScreen> createState() => _OtpPageScreenState();
}

class _OtpPageScreenState extends State<OtpPageScreen> {
  late TextEditingController otpController;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future authenticate() async {
    print("OTP ->>>>>>>>>>    ${otpController.text}");
    print("widget.vid ->>>>>>>>>>    ${widget.vid}");

    final PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
      smsCode: otpController.text,
      verificationId: widget.vid,
    );

    try {
      FirebaseAuth.instance.signInWithCredential(authCredential).then(
            (value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ItemBloc(ItemInitialState()),
                  child: AllItemsScreen(),
                ),
              ),
              (route) => false,
            ),
          );
    } on FirebaseAuthException catch (err) {
      print("FirebaseAuthException ERROR ->>>>>>>>>>    ${err}");

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.message.toString())));
    } catch (err) {
      print("err ->>>>>>>>>>    ${err}");

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }

    print("authCredential ->>>>>>>>>>>>>>>>>>>>>>>  ${authCredential}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: const Text(
                  // isNumberEntered ? "Verify your Phone" :
                  "Continue with Phone",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: otpController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  counterText: "",
                  prefixIcon: Icon(Icons.phone),
                  label: Text("Enter OTP"),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () async {
                    await authenticate();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: const Text(
                      "Verify",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
