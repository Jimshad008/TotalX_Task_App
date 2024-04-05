import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/Failure.dart';



abstract interface class AuthRepository {


  Future<Either<Failure, String>> loginWithPhoneNo(
      {required String phoneNo,required BuildContext context});
  Future<Either<Failure, String>> otpVerify(
      {required String verificationId,required String otp});
}