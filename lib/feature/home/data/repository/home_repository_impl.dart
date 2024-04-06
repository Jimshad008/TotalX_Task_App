import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/src/either.dart';
import 'package:totalx_task/core/error/Failure.dart';
import 'package:totalx_task/core/utils/set_search.dart';
import 'package:totalx_task/feature/home/data/dataSource/home_remote_data_source.dart';
import 'package:totalx_task/feature/home/data/model/user_data_model.dart';
import 'package:totalx_task/feature/home/domain/entities/user_data.dart';
import 'package:totalx_task/feature/home/domain/repository/home_repository.dart';

import '../../../../core/error/exception.dart';

class HomeRepositoryImpl implements HomeRepository{
  final HomeRemoteDataSource homeRemoteDataSource;
  const HomeRepositoryImpl(this.homeRemoteDataSource);
  @override
  Future<Either<Failure, UserData>> addUser({required String name, required String age, required File image,required,required String phoneNo}) async{
   try{
     final imageUrl=await homeRemoteDataSource.uploadImage(image: image);
     final user=UserDataModel(age: int.parse(age), name: name, imageUrl: imageUrl, phoneNo: phoneNo,search: setSearchParam(name.toUpperCase()) + setSearchParam(phoneNo.toUpperCase()));
     await homeRemoteDataSource.addUser(user);
     return right(user);

   } on ServerException catch (e) {
     return left(Failure( message: e.message));
   }
  }

  @override
  Future<Either<Failure, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>> getInitialUsers({required String search, required String ageFilter}) async{

 try{
   return right (await homeRemoteDataSource.getInitialUsers(search: search, ageFilter: ageFilter));
 } on ServerException catch (e) {
   return left(Failure( message: e.message));
 }
  }

  @override
  Future<Either<Failure, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>> getNextUsers({required String search, required String ageFilter, required lastDoc}) async{
    try{
      return right (await homeRemoteDataSource.getNextUsers(search: search, ageFilter: ageFilter,lastDoc: lastDoc));
    } on ServerException catch (e) {
    return left(Failure( message: e.message));
    }
  }
  
}