import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/error/exception.dart';
import '../../domain/repository/auth_repository.dart';
import '../dataSource/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  const AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, String>> loginWithPhoneNo({required String phoneNo,required BuildContext context}) async {
    try {
      final userId = await authRemoteDataSource.loginWithPhoneNo(context: context,
          phoneNo: phoneNo);

      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> otpVerify({required String verificationId, required String otp}) async {
    try {
      final userId = await authRemoteDataSource.verifyOtp(
          verificationId: verificationId, otp: otp);
      return right(userId);
    }on ServerException catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}