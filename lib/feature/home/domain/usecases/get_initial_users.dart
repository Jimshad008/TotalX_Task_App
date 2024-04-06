import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/src/either.dart';
import 'package:totalx_task/core/error/Failure.dart';
import 'package:totalx_task/core/usecases/usecases.dart';

import '../repository/home_repository.dart';

class GetInitialUsers implements UseCase<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>,InitialUserParam>{
  final HomeRepository homeRepository;
  GetInitialUsers(this.homeRepository);
  @override
  Future<Either<Failure, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>> call(InitialUserParam params)async {
 return await homeRepository.getInitialUsers(search: params.search, ageFilter: params.ageFilter);
  }

}
class InitialUserParam{
  final String search;
  final String ageFilter;
  InitialUserParam({required this.search,required this.ageFilter});
}