import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/exception.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> loginWithPhoneNo({
    required String phoneNo,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  const AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<String> loginWithPhoneNo({
    required String phoneNo,
  }) async {
    try {
      String? veriId;
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: "+91$phoneNo",
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
            await firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException error) {
            throw ServerException(message: error.toString());
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            veriId=verificationId;
          },
           codeAutoRetrievalTimeout: (String verificationId) {});
   if(veriId==null){
  throw const ServerException(message: "Error Occured");
   }
      return veriId!;
    }on FirebaseAuthException catch(e){
      throw ServerException(message: e.toString());
    }
    catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
