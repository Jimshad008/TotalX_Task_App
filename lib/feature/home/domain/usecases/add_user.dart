import 'dart:io';
import 'package:fpdart/src/either.dart';
import 'package:totalx_task/core/error/Failure.dart';
import 'package:totalx_task/feature/home/domain/entities/user_data.dart';
import 'package:totalx_task/feature/home/domain/repository/home_repository.dart';

import '../../../../core/usecases/usecases.dart';

class AddUser implements UseCase<UserData,UserParam>{
  final HomeRepository homeRepository;
  AddUser(this.homeRepository);

  @override
  Future<Either<Failure, UserData>> call(UserParam params) async{
   return await homeRepository.addUser(name: params.name, age: params.age, image: params.image,phoneNo: params.phoneNo);
  }
}
class UserParam{
  final String name;
  final String age;
  final File image;
  final String phoneNo;
  UserParam({
    required this.name,required this.image,required this.age,required this.phoneNo
});
}