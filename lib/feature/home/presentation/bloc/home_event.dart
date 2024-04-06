part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}
final class HomeAddUser extends HomeEvent{
  final String name;
  final String age;
  final File image;
  final String phoneNo;
  HomeAddUser({required this.age,required this.image,required this.name,required this.phoneNo});
}
final class HomeGetInitialUser extends HomeEvent{
  final String search;
  final String ageFilter;
  HomeGetInitialUser({
    required this.ageFilter,required this.search
});
}
final class HomeGetNextUser extends HomeEvent{
  final String search;
  final String ageFilter;
  final dynamic lastDoc;
  HomeGetNextUser({
    required this.ageFilter,required this.search,required this.lastDoc
  });
}