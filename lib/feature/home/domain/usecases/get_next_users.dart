import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/src/either.dart';
import 'package:totalx_task/core/error/Failure.dart';
import 'package:totalx_task/core/usecases/usecases.dart';

import '../repository/home_repository.dart';

class GetNextUsers implements UseCase<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>,NextUserParam>{
  final HomeRepository homeRepository;
  GetNextUsers(this.homeRepository);
  @override
  Future<Either<Failure, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>> call(NextUserParam params)async {
    return await homeRepository.getNextUsers(search: params.search, ageFilter: params.ageFilter, lastDoc: params.lastDoc);
  }

}
class NextUserParam{
  final String search;
  final String ageFilter;
  final dynamic lastDoc;
  NextUserParam({required this.search,required this.ageFilter,required this.lastDoc});
}