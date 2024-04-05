import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:totalx_task/core/constant/global%20constant.dart';

import '../../../../core/error/exception.dart';
import '../../presentation/pages/verify_otp_page.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> loginWithPhoneNo({
    required String phoneNo,
    required BuildContext context,
  });
  Future<String>verifyOtp({
    required String verificationId,
    required String otp
});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  const AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<String> loginWithPhoneNo({
    required String phoneNo,
    required BuildContext  context
  }) async {
    try {

    await firebaseAuth.verifyPhoneNumber(
          phoneNumber: "+91$phoneNo",
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
            await firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException error) {
            throw ServerException(message: error.toString());
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) =>  VerifyOtpPage(phoneNo: phoneNo,verificationId: verificationId),), (route) => false);

          },
           codeAutoRetrievalTimeout: (String verificationId) {});

      return "";
    }on FirebaseAuthException catch(e){
      throw ServerException(message: e.toString());
    }
    catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> verifyOtp({required String verificationId, required String otp}) async{
    try{
      PhoneAuthCredential credential=PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      final res=await firebaseAuth.signInWithCredential(credential);
      if(res.user==null){
        throw const ServerException(message: "Invalid Otp");
      }
    return res.user!.uid;
    }on FirebaseAuthException catch(e){
      throw ServerException(message: e.toString());
    }
    catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
