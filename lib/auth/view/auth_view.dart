import 'package:crud/all_items/bloc/items_bloc.dart';
import 'package:crud/auth/view/otp_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../all_items/view/all_items.dart';
import '../../constants/colors.dart';

class AuthViewScreen extends StatefulWidget {
  const AuthViewScreen({super.key});

  @override
  State<AuthViewScreen> createState() => _AuthViewScreenState();
}

class _AuthViewScreenState extends State<AuthViewScreen> {
  bool isNumberEntered = false;
  late TextEditingController mobileNumberController;
  late TextEditingController otpController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    mobileNumberController = TextEditingController();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    otpController.dispose();

    super.dispose();
  }

  Future authenticateUserByPhoneNumber({
    required BuildContext context,
    required String mobile,
  }) async {
    print("MOBIEL -<<<<<<<<    ${mobileNumberController.text}");

    await _auth.verifyPhoneNumber(
      phoneNumber: "+91$mobile",
      timeout: const Duration(seconds: 60),
      verificationCompleted: (phoneAuthCredential) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ItemBloc(ItemInitialState()),
              child: AllItemsScreen(),
            ),
          ),
        );
      },
      verificationFailed: (error) {
        print("error -<<<<<<<<    ${error}");

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message.toString())));
      },
      codeSent: (verificationId, forceResendingToken) {
        // final smsCode = otpController.text.trim();

        // final AuthCredential authCredential = PhoneAuthProvider.credential(
        //   smsCode: smsCode,
        //   verificationId: verificationId,
        // );

        // print("authCredential   ---------     ${authCredential}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return OtpPageScreen(vid: verificationId);
            },
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
    print("DONE ->>>>>>>>>>>>>>>>>>>>>>>");
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
                child: Text(
                  // isNumberEntered ? "Verify your Phone" :
                  "Continue with Phone",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // isNumberEntered
              //     ? TextField(
              //         controller: otpController,
              //         inputFormatters: [
              //           FilteringTextInputFormatter.digitsOnly,
              //         ],
              //         maxLength: 10,
              //         keyboardType: TextInputType.number,
              //         decoration: const InputDecoration(
              //           counterText: "",
              //           prefixIcon: Icon(Icons.phone),
              //           label: Text("Enter OTP"),
              //           border: OutlineInputBorder(
              //             borderSide: BorderSide(color: borderColor),
              //           ),
              //         ),
              //       )
              //     :
              TextField(
                onChanged: (value) {
                  if (value.length == 10) {
                    setState(() {
                      isNumberEntered = true;
                    });
                  }
                },
                controller: mobileNumberController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  counterText: "",
                  prefixIcon: Icon(Icons.phone),
                  label: Text("Mobile Number"),
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
                    //

                    if (isNumberEntered) {
                      await authenticateUserByPhoneNumber(
                        context: context,
                        mobile: mobileNumberController.text,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter mobile number")),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Text(
                      // isNumberEntered ? "Verify" :
                      "CONTINUE",
                      style: const TextStyle(
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
