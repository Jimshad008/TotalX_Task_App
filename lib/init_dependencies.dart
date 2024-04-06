import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:totalx_task/feature/auth/domain/usecases/otp_verify.dart';
import 'package:totalx_task/feature/auth/domain/usecases/user_login.dart';
import 'package:totalx_task/feature/home/domain/usecases/add_user.dart';
import 'package:totalx_task/feature/home/domain/usecases/get_initial_users.dart';

import 'feature/auth/data/dataSource/auth_remote_data_source.dart';
import 'feature/auth/data/repository/auth_repository_implement.dart';
import 'feature/auth/domain/repository/auth_repository.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';
import 'feature/home/data/dataSource/home_remote_data_source.dart';
import 'feature/home/data/repository/home_repository_impl.dart';
import 'feature/home/domain/repository/home_repository.dart';
import 'feature/home/domain/usecases/get_next_users.dart';
import 'feature/home/presentation/bloc/home_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initHome();
  final firebaseAuth = FirebaseAuth.instance;
  final firestore=FirebaseFirestore.instance;
  final firebaseStorage=FirebaseStorage.instance;

  serviceLocator.registerLazySingleton(() => firebaseAuth);
  serviceLocator.registerLazySingleton(() => firestore);
  serviceLocator.registerLazySingleton(() => firebaseStorage);
}
_initAuth(){
  serviceLocator.registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
        () => OtpVerify(
      serviceLocator(),
    ),

  );

  serviceLocator.registerFactory(
        () => UserLogin(
      serviceLocator(),
    ),

  );
  serviceLocator.registerLazySingleton(
        () => AuthBloc(userLogin: serviceLocator(), otpVerify: serviceLocator(),
    ),
  );
}
_initHome(){
  serviceLocator.registerFactory<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(
      serviceLocator(),serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<HomeRepository>(
        () => HomeRepositoryImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
        () => AddUser(
      serviceLocator(),
    ),

  );
  serviceLocator.registerFactory(
        () => GetInitialUsers(
      serviceLocator(),
    ),

  );
  serviceLocator.registerFactory(
        () => GetNextUsers(
      serviceLocator(),
    ),

  );
  serviceLocator.registerLazySingleton(
        () => HomeBloc(addUser: serviceLocator(), getInitialUsers: serviceLocator(), getNextUsers: serviceLocator()
    ),
  );
}
