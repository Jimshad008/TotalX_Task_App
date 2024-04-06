import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:totalx_task/feature/auth/domain/usecases/user_login.dart';

import '../../domain/usecases/otp_verify.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogin _userLogin;
  final OtpVerify _otpVerify;

  AuthBloc({required UserLogin userLogin,required OtpVerify otpVerify}) : _userLogin=userLogin,_otpVerify=otpVerify,super(AuthInitial()) {
    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
final res=await _userLogin.authRepository.loginWithPhoneNo(phoneNo: event.phoneNo,context: event.context);
res.fold(
      (l) => emit(AuthFailure( l.message)),
      (uid) => emit(AuthSuccess( uid)),
);
    });
    on<AuthOtpVerify>((event,emit)async{
      emit(AuthLoading());
      final res=await _userLogin.authRepository.otpVerify(verificationId: event.verificationId, otp: event.otp);
      res.fold(
            (l) => emit(AuthFailure( l.message)),
            (uid) => emit(AuthSuccess( uid)),
      );
       });
  }
}
