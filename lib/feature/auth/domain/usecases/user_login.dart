import 'package:fpdart/fpdart.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repository/auth_repository.dart';

class UserSignUp implements UseCase<String,String> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, String>> call(String phoneNo) async{

      return await authRepository.loginWithPhoneNo(phoneNo: phoneNo);

  }

}