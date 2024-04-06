part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}
final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final StreamSubscription<QuerySnapshot<Map<String,dynamic>>>? success;
  const HomeSuccess(this.success);
}
final class HomeSuccess1 extends HomeState {
  final StreamSubscription<QuerySnapshot<Map<String,dynamic>>>? success;
  const HomeSuccess1(this.success);
}

final class HomeFailure extends HomeState {
  final String message;
  const  HomeFailure(this.message);
}