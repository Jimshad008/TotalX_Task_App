import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:totalx_task/feature/home/data/model/user_data_model.dart';
import 'package:totalx_task/feature/home/domain/entities/user_data.dart';

import '../../../../core/error/Failure.dart';

abstract interface class HomeRepository{
  Future<Either<Failure, UserData>> addUser({
    required String name,
    required String age,
    required File image,
    required String phoneNo
});
  Future<Either<Failure, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>>getInitialUsers({
    required String search,
    required String ageFilter
});
  Future<Either<Failure, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>>getNextUsers({
    required String search,
    required String ageFilter,
    required dynamic lastDoc,
  });
}