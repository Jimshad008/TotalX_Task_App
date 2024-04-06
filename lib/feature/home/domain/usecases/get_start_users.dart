import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usecases/usecases.dart';
import '../repository/home_repository.dart';

class GetStartUsers implements UseCase<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>,void> {
  final HomeRepository homeRepository;

  GetStartUsers(this.homeRepository);

  @override
  Future<Either<Failure,
      StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>> call(
      void a) async {
    return await homeRepository.getStartUsers();
  }

}