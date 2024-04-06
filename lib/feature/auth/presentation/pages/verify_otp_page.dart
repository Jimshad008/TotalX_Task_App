import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:totalx_task/feature/auth/presentation/pages/login_page.dart';



import '../../../../core/common/loader.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../bloc/auth_bloc.dart';

class VerifyOtpPage extends StatefulWidget {
  final String phoneNo;
 final  String verificationId;
  const VerifyOtpPage({super.key,required this.phoneNo,required this.verificationId});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  int _secondsRemaining = 90;
  late Timer _timer;
  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_secondsRemaining == 0) {
          timer.cancel();
          if(mounted){
            setState(() {

            });
          }

        } else {
            _secondsRemaining--;

          if(mounted){
            setState(() {

            });
          }
        }
      },
    );
  }
  TextEditingController otpController = TextEditingController();
  @override
  void dispose() {
  otpController.dispose();
    super.dispose();
  }
@override
  void initState() {
  Future.delayed(const Duration(seconds: 91)).then((value) {
    showSnackBar(context, "Session Expired");
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const LoginPage(),), (route) => false);
  });
    _startTimer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String timerText = '$_secondsRemaining sec';
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      SafeArea(
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child:BlocConsumer<AuthBloc,AuthState>(builder: (context, state) {
              if(state is AuthLoading){
                return const Loader();
              }
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),
                    SizedBox(
                      height: height * 0.18,
                      width: width,
                      child: Image.asset('assets/otp_image.png'),
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    Text(
                      'OTP Verification',
                      style: TextStyle(
                          fontSize: width * 0.045, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: height * 0.035,
                    ),
                    Text(
                      'Enter the verification code we just sent to your number +91 ********${widget.phoneNo.substring(8, 10)}',
                      style: TextStyle(fontSize: width * 0.04, color: Colors.grey.shade600),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Pinput(
                      submittedPinTheme:  PinTheme(
                          textStyle: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: width*0.05,
                          ),
                          width: width*0.15,
                          height: width*0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width*0.03),

                              border: Border.all(color: Colors.black,width: 2)
                          )),
                      defaultPinTheme: PinTheme(
                          textStyle: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: width*0.05,
                          ),
                          width: width*0.15,
                          height: width*0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width*0.03),

                              border: Border.all(color: Colors.grey,width: 2)
                          )),
                      cursor: const SizedBox(),
                      disabledPinTheme: PinTheme(
                          textStyle: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: width*0.05,
                          ),
                          width: width*0.15,
                          height: width*0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width*0.03),

                              border: Border.all(color: Colors.grey,width: 2)
                          )),
                      focusedPinTheme:  PinTheme(
                          textStyle: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: width*0.05,
                          ),
                          width: width*0.15,
                          height: width*0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width*0.03),

                              border: Border.all(color: Colors.black,width: 2)
                          )),

                      controller: otpController,
                      keyboardType: TextInputType.number,
                      length: 6,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    SizedBox(
                      width: width,
                      child: Center(child: Text(timerText,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Get OTP?",
                          style: TextStyle(fontSize: width * 0.035),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<AuthBloc>().add(AuthLogin(phoneNo: widget.phoneNo, context: context));
                          },
                          child: Text(
                            'Resend',
                            style: TextStyle(
                                decorationColor:const Color(0xff2873F0) ,
                                color: const Color(0xff2873F0),
                                decoration: TextDecoration.underline,
                                fontSize: width * 0.035),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height*0.02,
                    ),
                    InkWell(
                      onTap: () {
                        context.read<AuthBloc>().add(AuthOtpVerify(otp: otpController.text.trim(), verificationId: widget.verificationId));
                      },
                      child: Container(
                        height: height * 0.06,
                        width: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(height * 0.25),
                            color: Colors.black),
                        child: Center(
                          child: Text(
                            'Verify',
                            style:
                            TextStyle(fontSize: width * 0.04, color: Colors.white,fontFamily: "Montserrat",fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }, listener: (context, state) async {
              if (state is AuthFailure) {
                showSnackBar(context, state.message.toString());
              } else if (state is AuthSuccess) {
                if(state.success==""){
                  showSnackBar(context, "Otp is Resend to your Phone Number");
                }
                else{
                 final SharedPreferences local=await SharedPreferences.getInstance();
                 local.setString("uid", state.success);

                  showSnackBar(context, "Otp Verification Successful");
                  Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) =>const HomePage() ,), (route) => false);
                }





              }
            },),

          ),
        ),
      ),
    );

  }
}
