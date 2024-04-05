import 'package:fpdart/fpdart.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repository/auth_repository.dart';

class OtpVerify implements UseCase<String,OtpVerifyParam> {
  final AuthRepository authRepository;
  const OtpVerify(this.authRepository);

  @override
  Future<Either<Failure, String>> call(OtpVerifyParam param) async{
    return await authRepository.otpVerify(verificationId:param. verificationId, otp: param.otp);

  }

}
class OtpVerifyParam{
  final String verificationId;
  final String otp;
  OtpVerifyParam({required this.verificationId,required this.otp});
}