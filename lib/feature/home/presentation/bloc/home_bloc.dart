import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:totalx_task/feature/home/domain/entities/user_data.dart';

import '../../domain/usecases/add_user.dart';
import '../../domain/usecases/get_initial_users.dart';
import '../../domain/usecases/get_next_users.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AddUser _addUser;
  final  GetInitialUsers _getInitialUser;
  final  GetNextUsers _getNextUsers;
  HomeBloc({required AddUser addUser,required GetInitialUsers getInitialUsers,required GetNextUsers getNextUsers}) :_addUser=addUser,_getInitialUser=getInitialUsers,_getNextUsers=getNextUsers, super(HomeInitial()) {
    on<HomeAddUser>((event, emit) async {
     final res=await _addUser.homeRepository.addUser(name:event.name, age: event.age, image: event.image, phoneNo: event.phoneNo);
     res.fold(
           (l) => emit(HomeFailure( l.message)),
           (uid) => emit(const HomeSuccess( null)),
     );
    });
    on<HomeGetInitialUser>((event,emit)async{
      final res=await _getInitialUser.homeRepository.getInitialUsers(search: event.search, ageFilter: event.ageFilter);
      res.fold(
            (l) => emit(HomeFailure( l.message)),
            (uid) => emit(HomeSuccess( uid)),
      );
    });
    on<HomeGetNextUser>((event,emit)async{
      final res=await _getInitialUser.homeRepository.getNextUsers(search: event.search, ageFilter: event.ageFilter, lastDoc: event.lastDoc);
      res.fold(
            (l) => emit(HomeFailure( l.message)),
            (uid) => emit(HomeSuccess1( uid)),
      );
    });
  }
}
