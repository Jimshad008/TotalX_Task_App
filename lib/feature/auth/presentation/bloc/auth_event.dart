part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}
final class AuthLogin extends AuthEvent {
  final String phoneNo;
  final BuildContext context;

  AuthLogin({
    required this.phoneNo,
    required this.context,
  });
}
final class AuthOtpVerify extends AuthEvent{
  final String verificationId;
  final String otp;
  AuthOtpVerify({
    required this.otp,required this.verificationId
});
}