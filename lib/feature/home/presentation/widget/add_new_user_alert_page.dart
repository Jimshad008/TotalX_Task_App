import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:totalx_task/feature/home/presentation/bloc/home_bloc.dart';

import '../../../../core/common/loader.dart';
import '../../../../core/utils/pick_image.dart';
import '../../../../core/utils/show_snackbar.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  TextEditingController nameController=TextEditingController();
  TextEditingController ageController=TextEditingController();
  TextEditingController phoneNoController=TextEditingController();
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
  nameController.dispose();
  ageController.dispose();
  phoneNoController.dispose();
  }
  @override
  Widget build(BuildContext context) {
   var  width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;


   return  BlocConsumer<HomeBloc,HomeState>(builder: (context, state) {
      if(state is HomeLoading){
        return const Loader();
      }
     return  AlertDialog(
        title: const Text('Add A New User'),
        content: SizedBox(
          height: height*0.45,
          width: width*0.95,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        selectImage();

                      },
                        child: image==null?CircleAvatar(
                          radius: width*0.11,
                          backgroundImage: const AssetImage('assets/default_avatar.png'),
                         ):CircleAvatar(
                          radius: width*0.11,
                          backgroundImage:  FileImage(image!),
                        )),
                  ),
                ),
                SizedBox(height: height*0.01,),
                const Text('Name'),
                SizedBox(height: height*0.01,),
                SizedBox(
                  height: height * 0.06,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(
                            fontSize: width * 0.035, color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade100))),
                  ),
                ),
                SizedBox(height: height*0.01,),
                const Text('Age'),
                SizedBox(height: height*0.01,),
                SizedBox(
                  height: height * 0.06,
                  child: TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
                    decoration: InputDecoration(
                        hintText: 'Age',
                        hintStyle: TextStyle(
                            fontSize: width * 0.035, color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade100))),
                  ),
                ),
                SizedBox(height: height*0.01,),
                const Text('Phone Number'),
                SizedBox(height: height*0.01,),
                SizedBox(
                  height: height * 0.06,
                  child: TextFormField(
                    controller: phoneNoController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(
                            fontSize: width * 0.035, color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade100))),
                  ),
                ),
              ],),
          ),
        ),
        actions: [
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
             if(nameController.text.trim().isNotEmpty&&ageController.text.trim().isNotEmpty&&phoneNoController.text.trim().isNotEmpty&&image!=null){
               if(phoneNoController.text.trim().length==10){
                 context.read<HomeBloc>().add(HomeAddUser(age: ageController.text.trim(), image: image!, name: nameController.text.trim(), phoneNo: phoneNoController.text.trim()));
               }
               else{
                 showSnackBar(context, "Enter 10 digit Number");
               }
             }
             else{
               nameController.text.trim().isEmpty?showSnackBar(context, "Please Enter Name"):ageController.text.trim().isEmpty?showSnackBar(context, "Please Enter Age"):phoneNoController.text.trim().isEmpty?showSnackBar(context, "Please Enter Phone number"):showSnackBar(context, "Please Select an Image");
             }
            },
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xff1782FF)),
              height: height*0.04,width: width*0.25,child: const Center(child: Text('Save',style: TextStyle(color: Colors.white,fontFamily:"Montserrat"),),),),
          )
        ],
      );
    }, listener: (context, state) {
      if (state is HomeFailure) {
        showSnackBar(context, state.message);
      } else if (state is HomeSuccess) {
        Navigator.pop(context);
        showSnackBar(context, "New User Added");


      }
    },);

  }
}
