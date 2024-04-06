import 'package:totalx_task/feature/home/domain/entities/user_data.dart';

class UserDataModel extends UserData{

  UserDataModel({required super.age,required super.name,required super.imageUrl,required super.search,required super.phoneNo});


  UserDataModel copyWith({
    String? name,
    int? age,
    List? search,
    String? imageUrl,
    String? phoneNo
  }) {
    return UserDataModel(
      name: name ?? this.name,
      age: age ?? this.age,
      search: search ?? this.search,
      imageUrl: imageUrl ?? this.imageUrl,
        phoneNo:phoneNo??this.phoneNo
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'age': this.age,
      'search': this.search,
      'imageUrl': this.imageUrl,
      "phoneNo":this.phoneNo,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      name: map['name']??'',
      age: map['age']??0,
      search: map['search']??[],
      imageUrl: map['imageUrl']??"",
        phoneNo:map["phoneNo"]??""
    );
  }

//</editor-fold>
}