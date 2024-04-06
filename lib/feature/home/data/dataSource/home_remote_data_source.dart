import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:totalx_task/core/constant/firebase_constant.dart';
import 'package:totalx_task/core/constant/global%20constant.dart';
import 'package:totalx_task/feature/home/data/model/user_data_model.dart';

import '../../../../core/error/exception.dart';

abstract interface class HomeRemoteDataSource {
  Future<UserDataModel> addUser(UserDataModel user);
  Future<String>uploadImage({
    required File image,

  });
  Future <StreamSubscription<QuerySnapshot<Map<String, dynamic>>>> getInitialUsers({
    required String search,required String ageFilter

});
  Future <StreamSubscription<QuerySnapshot<Map<String, dynamic>>>> getNextUsers({
    required String search,required String ageFilter,required dynamic lastDoc

  });
}
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource{
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  HomeRemoteDataSourceImpl(this.firebaseStorage,this.firestore);
  @override
  Future<UserDataModel> addUser(UserDataModel user) async {
  try{

    await firestore.collection(FirebaseConstants.userCollection).add(user.toMap());
    return user;
  }on FirebaseException catch(e){
    throw ServerException(message: e.toString());
  } catch(e){
    throw ServerException(message: e.toString());
  }
  }

  @override
  Future<String> uploadImage({required File image}) async {
    try{
      final Reference storageRef =
      firebaseStorage.ref().child('images/profile/${DateTime.now().toString()}-${image.path}');
      final UploadTask uploadTask = storageRef.putFile(image);
      final res=await uploadTask;
        // Get download URL
       return (await res.ref.getDownloadURL());

    }on FirebaseException catch(e){
        throw ServerException(message: e.toString());
      } catch(e){
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>> getInitialUsers({required String search, required String ageFilter}) async {
   try{
     if(search.isEmpty){
       if(ageFilter=="Younger"){
         return  firestore.collection(FirebaseConstants.userCollection).where("age",isLessThan: 60).limit(limit).snapshots().listen((event) {
         });
       }
       else if(ageFilter=="Elder"){
         return  firestore.collection(FirebaseConstants.userCollection).where("age",isGreaterThanOrEqualTo: 60).limit(limit).snapshots().listen((event) {
         });
       }
       else{
         return  firestore.collection(FirebaseConstants.userCollection).limit(limit).snapshots().listen((event) {
         });
       }
     }
     else{
       if(ageFilter=="Younger"){
         return  firestore.collection(FirebaseConstants.userCollection).where("age",isLessThan: 60).where("search",arrayContains: search.toUpperCase()).limit(limit).snapshots().listen((event) {
         });
       }
       else if(ageFilter=="Elder"){
         return  firestore.collection(FirebaseConstants.userCollection).where("age",isGreaterThanOrEqualTo: 60).where("search",arrayContains: search.toUpperCase()).limit(limit).snapshots().listen((event) {
         });
       }
       else{
         return  firestore.collection(FirebaseConstants.userCollection).where("search",arrayContains: search.toUpperCase()).limit(limit).snapshots().listen((event) {
         });
       }
     }

   }on FirebaseException catch(e){
     throw ServerException(message: e.toString());
   } catch(e){
     throw ServerException(message: e.toString());
   }
  }

  @override
  Future<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>> getNextUsers({required String search, required String ageFilter, required lastDoc}) async{
    try{
      if(search.isEmpty){
        if(ageFilter=="Younger"){
          return  firestore.collection(FirebaseConstants.userCollection).where("age",isLessThan: 60).startAfterDocument(lastDoc).limit(limit).snapshots().listen((event) {
          });
        }
        else if(ageFilter=="Elder"){
          return  firestore.collection(FirebaseConstants.userCollection).where("age",isGreaterThanOrEqualTo: 60).startAfterDocument(lastDoc).limit(limit).snapshots().listen((event) {
          });
        }
        else{
          return  firestore.collection(FirebaseConstants.userCollection).startAfterDocument(lastDoc).limit(limit).snapshots().listen((event) {
          });
        }
      }
      else{
        if(ageFilter=="Younger"){
          return  firestore.collection(FirebaseConstants.userCollection).where("age",isLessThan: 60).where("search",arrayContains: search.toUpperCase()).startAfterDocument(lastDoc).limit(limit).snapshots().listen((event) {
          });
        }
        else if(ageFilter=="Elder"){
          return  firestore.collection(FirebaseConstants.userCollection).where("age",isGreaterThanOrEqualTo: 60).where("search",arrayContains: search.toUpperCase()).startAfterDocument(lastDoc).limit(limit).snapshots().listen((event) {
          });
        }
        else{
          return  firestore.collection(FirebaseConstants.userCollection).where("search",arrayContains: search.toUpperCase()).startAfterDocument(lastDoc).limit(limit).snapshots().listen((event) {
          });
        }
      }

    }on FirebaseException catch(e){
      throw ServerException(message: e.toString());
    } catch(e){
      throw ServerException(message: e.toString());
    }
  }

}