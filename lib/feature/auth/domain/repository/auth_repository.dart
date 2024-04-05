import 'package:fpdart/fpdart.dart';

import '../../../../core/error/Failure.dart';



abstract interface class AuthRepository {


  Future<Either<Failure, String>> loginWithPhoneNo(
      {required String phoneNo});
}