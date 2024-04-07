

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:totalx_task/core/common/loader.dart';
import 'package:totalx_task/feature/home/presentation/bloc/home_bloc.dart';
import 'package:totalx_task/feature/home/presentation/widget/add_new_user_alert_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/show_snackbar.dart';
import '../../data/model/user_data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentLocation = '';


  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        return;
      }

      PermissionStatus permission = await Permission.location.status;
      if (permission == PermissionStatus.denied) {
        // Permission to access location is denied
        permission = await Permission.location.request();
        if (permission != PermissionStatus.granted) {
          // Permission still not granted, handle accordingly
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Reverse geocoding to get location name
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      Placemark placemark = placemarks[0];

      setState(() {
        _currentLocation = placemark.locality!;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  double height=0.0;
  double width=0.0;
  final TextEditingController searchController=TextEditingController();
  String search="";
  String ageFilter="All";
  bool isLoadingVertical = false;
  var lastDoc;
  List<UserDataModel> userList=[];
  @override
  void initState() {
    _getCurrentLocation();
    context.read<HomeBloc>().add(HomeGetStartUser());
    super.initState();
  }
  @override
  void deactivate() {
   searchController.dispose();
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    print(_currentLocation);
    print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            const Icon(
              Icons.location_pin,
              color: Colors.white,
            ),
            Text(
              _currentLocation==""?"Nilambur":_currentLocation,
              style: TextStyle(fontSize: width * 0.045, color: Colors.white,fontFamily: "Montserrat"),
            ),
          ],
        ),

      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child:
        Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: Padding(
            padding: EdgeInsets.only(
                left: width * 0.03, right: width * 0.03, top: width * 0.03),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height * 0.06,
                        width: width * 0.8,
                        decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(height * 0.3),
                          border: Border.all(


                              color: Colors.grey.shade600,
                            width: 2

                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width*0.58,
                              child: TextFormField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: height*0.006,top: height*0.002),
                                  prefixIcon: const Icon(Icons.search),
                                 border: InputBorder.none,
                                  hintText: 'Search by Name/Phone',
                                  hintStyle: TextStyle(
                                      fontSize: width * 0.035,
                                      color: Colors.grey.shade600,fontFamily: "Montserrat"),
                                  // hintText: 'Enter Phone Number *',
                                  // hintStyle: TextStyle(fontSize: width*0.035,color: Colors.grey),

                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context.read<HomeBloc>().add(HomeGetInitialUser(ageFilter: ageFilter, search: searchController.text.trim()));
                              },
                              child: Container(
                                width: width*0.18,
                                height: height*0.04,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(width*0.05),
                                  color: Colors.grey.shade400
                                ),
                                child: Center(
                                  child: Text("Search",style: TextStyle(
                                      fontSize: width * 0.035,
                                      color: Colors.grey.shade800,fontFamily: "Montserrat",fontWeight: FontWeight.bold
                                  ),),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          sortingBox(context: context);
                        },
                        child: Container(
                          height: height * 0.05,
                          width: height * 0.05,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black),
                          child: const Icon(
                            Icons.filter_list_sharp,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    'Users List',
                    style: TextStyle(
                        fontSize: width * 0.04, color: Colors.grey.shade700,fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  BlocConsumer<HomeBloc,HomeState>(builder: (context, state) {
                  if(state is HomeLoading){
                     return const Loader();
                      }

                    if(state is HomeSuccess){
                      final result=state.success;
                      result?.onData((data) {
                        print(data.docs.length);
                        print("@@@@@2222###################");
                        if(data.docs.isNotEmpty){
                          userList=[];
                          for (DocumentSnapshot doc in data.docs) {
                            userList.add(UserDataModel.fromMap(doc.data()as Map<String,dynamic>));
                          }
                          if(userList.isNotEmpty){
                            lastDoc = data.docs.last;
                          }

                          if(mounted){
                            setState(() {

                            });
                          }
                        }
                        else{
                          userList.clear();
                        }

                      });
                      return Stack(
                        children: [


                          SizedBox(
                            height: height*0.75,
                            child: LazyLoadScrollView(
                              isLoading: isLoadingVertical,
                              scrollDirection: Axis.vertical,
                              onEndOfPage: () async{
                                print("11111111111111111111111");

                                setState(() {
                                  isLoadingVertical = true;
                                });

                                Future.delayed(const Duration(seconds: 2)).then((value){
                                  context.read<HomeBloc>().add(HomeGetNextUser(ageFilter: ageFilter, search: searchController.text.trim(), lastDoc: lastDoc));
                                  setState(() {
                                    isLoadingVertical = false;
                                  });
                                });

                              },
                              child: Scrollbar(
                                child: userList.isEmpty?SizedBox(
                                  child: Image.asset("assets/noSearchFound.png"),
                                ):ListView.builder(
                                    shrinkWrap: true,
                                    // physics: const NeverScrollableScrollPhysics(),
                                    itemCount: userList.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Container(
                                        height: height * 0.1,
                                        width: width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(6),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                   userList[index].imageUrl),
                                                radius: height * 0.05,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  userList[index].name,
                                                  style: TextStyle(
                                                      fontSize: width * 0.04,
                                                      color: Colors.black,fontFamily: "Montserrat"),
                                                ),

                                                Text(
                                                  userList[index].phoneNo,
                                                  style: TextStyle(
                                                      fontSize: width * 0.04,
                                                      color: Colors.black,fontFamily: "Montserrat"),
                                                ),

                                                Text(
                                                  'Age: ${ userList[index].age}',
                                                  style: TextStyle(
                                                      fontSize: width * 0.035,
                                                      color: Colors.grey.shade600,fontFamily: "Montserrat"),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          if(isLoadingVertical)
                            Positioned(
                                bottom: 0,
                                left: width*0.45,
                                child:  SizedBox(
                                  width: width*0.05,
                                    height:width*0.05,
                                    child: const Loader())),
                        ],
                      );
                    }
                  if(state is HomeSuccess1){
                    final result=state.success;
                    result?.onData((data) {
                      if(data.docs.isNotEmpty){
                        for (DocumentSnapshot doc in data.docs) {
                          userList.add(UserDataModel.fromMap(doc.data()as Map<String,dynamic>));
                        }
                        if(userList.isNotEmpty){
                          lastDoc = data.docs.last;
                        }

                        if(mounted){
                          setState(() {

                          });
                        }
                      }

                    });
                    return Stack(
                      children: [

                        SizedBox(
                          height: height*0.75,
                          child: LazyLoadScrollView(
                            isLoading: isLoadingVertical,
                            scrollDirection: Axis.vertical,
                            onEndOfPage: () async{
                              setState(() {
                                isLoadingVertical = true;
                              });

                              Future.delayed(const Duration(seconds: 2)).then((value){
                                context.read<HomeBloc>().add(HomeGetNextUser(ageFilter: ageFilter, search: searchController.text.trim(), lastDoc: lastDoc));
                                setState(() {
                                  isLoadingVertical = false;
                                });
                              });


                            },
                            child: Scrollbar(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemCount: userList.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Container(
                                      height: height * 0.1,
                                      width: width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  userList[index].imageUrl),
                                              radius: height * 0.05,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                userList[index].name,
                                                style: TextStyle(
                                                    fontSize: width * 0.04,
                                                    color: Colors.black,fontFamily: "Montserrat"),
                                              ),


                                              Text(
                                                userList[index].phoneNo,
                                                style: TextStyle(
                                                    fontSize: width * 0.04,
                                                    color: Colors.black,fontFamily: "Montserrat"),
                                              ),

                                              Text(
                                                'Age: ${ userList[index].age}',
                                                style: TextStyle(
                                                    fontSize: width * 0.035,
                                                    color: Colors.grey.shade600,fontFamily: "Montserrat"),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        if(isLoadingVertical)
                          Positioned(
                              bottom: 0,
                              left: width*0.45,
                              child: SizedBox(
                                  width: width*0.07,
                                  height:width*0.07,
                                  child: const Loader())),
                      ],
                    );
                  }
                    else{
                      return const Text("not Found");
                    }

                  }, listener: (context, state) {
                    if (state is HomeFailure) {
                      showSnackBar(context, state.message);
                    }
                  },)

                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
         showDialog(context: context, builder: (context) =>  const AddNewUser(),);
        },
        child: CircleAvatar(
          radius: width * 0.085,
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: width * 0.08,
          ),
        ),
      ),

    );
  }

  void sortingBox({required BuildContext context}){
    int sortingValue=ageFilter=="All"?0:ageFilter=="Younger"?2:1;
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Sort'),
      content: StatefulBuilder(
        builder:(context, setState) =>  SizedBox(
          height: height*0.3,
          child: Column(
            children: [
              Row(
                children: [
                  Radio(value:0, groupValue: sortingValue, onChanged:(value) {
                    setState((){
                      sortingValue=value!;
                      ageFilter="All";
                    });
                  },),
                  const SizedBox(width: 10,),
                  const Text('All')
                ],
              ),Row(
                children: [
                  Radio(value:1, groupValue: sortingValue, onChanged:(value) {
                    setState((){
                      sortingValue=value!;
                      ageFilter="Elder";
                    });                },),
                  SizedBox(width: 10,),
                  Text('Age: Elder')
                ],
              ),Row(
                children: [
                  Radio(value:2, groupValue: sortingValue, onChanged:(value) {
                    setState((){
                      sortingValue=value!;
                      ageFilter="Younger";
                    });
                  },),
                  SizedBox(width: 10,),
                  Text('Age: Younger')
                ],
              ),
              SizedBox(
                height: height*0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey.shade400),
                      height: height*0.04,width: width*0.25,child:  Center(child: Text('Cancel',style: TextStyle(fontFamily:"Montserrat",color: Colors.grey.shade700),),),),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.read<HomeBloc>().add(HomeGetInitialUser(ageFilter: ageFilter, search: searchController.text.trim()));
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xff1782FF)),
                      height: height*0.04,width: width*0.25,child: const Center(child: Text('Ok',style: TextStyle(color: Colors.white,fontFamily:"Montserrat"),),),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ),);

  }
}
