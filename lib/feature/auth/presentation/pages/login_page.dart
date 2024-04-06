import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:totalx_task/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:totalx_task/feature/auth/presentation/pages/verify_otp_page.dart';

import '../../../../core/common/loader.dart';
import '../../../../core/utils/show_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneNo=TextEditingController();
  @override
  void dispose() {
    super.dispose();
    phoneNo.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      

backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocConsumer<AuthBloc,AuthState>(builder: (context, state) {
          if(state is AuthLoading){
            return const Loader();
          }
         return  SingleChildScrollView(
            child: Container(
              width: width,
              height: height,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(right: width*0.05,left: width*0.05),
                child: Column(
                  children: [
                    SizedBox(
                      width: width*0.5,
                      height: height*0.4,
                      child:Image.asset("assets/login_image.png",fit: BoxFit.contain,),

                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: width*0.02),
                      child: SizedBox(
                        width: width,
                        child: Text(
                          "Enter Phone Number",style: TextStyle(
                            fontWeight: FontWeight.bold,fontFamily: "Montserrat",
                            fontSize: width*0.05
                        ),
                        ),
                      ),
                    ),
                    SizedBox(height: height*0.02,),
                    SizedBox(
                      width: width*0.9,
                      height: height*0.08,
                      child: TextFormField(

                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                        cursorColor: Colors.grey,


                        controller: phoneNo,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: const Color(0xFF57636C),
                            fontSize: width*0.035,
                            fontWeight: FontWeight.normal,
                          ),
                          hintText: 'Enter Phone Number *',
                          hintStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: const Color(0xFF57636C),

                            fontSize: width*0.035,
                            fontWeight: FontWeight.normal,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:  BorderSide(
                              color:Colors.blueAccent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(top: height*0.015,left: width*0.05),
                        ),
                        style:TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: const Color(0xFF1D2429),
                          fontSize: width*0.035,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width*0.9,
                      height: height*0.05,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("By Continuing, I agree to TotalX’s",style: TextStyle(fontSize: width*0.034),),
                              Text(" Terms and condition ",style: TextStyle(fontSize: width*0.034,color: Colors.lightBlueAccent)),
                              Text("&",style: TextStyle(fontSize: width*0.034))

                            ],
                          ),
                          Text("privacy policy",style: TextStyle(fontSize: width*0.034,color: Colors.lightBlueAccent),)
                        ],
                      ),
                    ),
                    SizedBox(height: height*0.02,),
                    GestureDetector(
                      onTap: () {
                        if(phoneNo.text.trim().length<10){
                          showSnackBar(context, "Please Enter 10 Digit Phone Number");
                        }else{
                          context.read<AuthBloc>().add(AuthLogin(phoneNo: phoneNo.text.trim(), context: context));
                        }

                      },
                      child: Container(
                        width: width*0.9,
                        height: height*0.07,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(width*0.08)
                        ),
                        child: Center(child: Text("Get OTP",style: TextStyle(fontSize: width*0.05,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Montserrat",),)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }, listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          } else if (state is AuthSuccess) {
            showSnackBar(context, "Otp sent to your phone number");


          }
        },),


      ),
    );
  }
}
