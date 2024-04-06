import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:totalx_task/core/constant/global%20constant.dart';
import 'package:totalx_task/feature/auth/presentation/pages/login_page.dart';
import 'package:totalx_task/feature/home/presentation/pages/home_page.dart';

import 'feature/auth/presentation/bloc/auth_bloc.dart';
import 'feature/home/presentation/bloc/home_bloc.dart';
import 'firebase_options.dart';
import 'init_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  await initDependencies();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => serviceLocator<AuthBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<HomeBloc>(),
    ),
  ],
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'TotalX Task App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),

        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  keepLogin() async {
    final SharedPreferences local=await SharedPreferences.getInstance();
    userId=local.getString("uid");
    if(userId==null){
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const LoginPage(),), (route) => false);
    }
    else{
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const HomePage(),), (route) => false);
    }
  }
  addData(){
   Future.delayed(const Duration(seconds: 2)).then((value) =>
  keepLogin());
  }
@override
  void initState() {
 addData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
     backgroundColor: Colors.black,
      body: Center(child: Image.asset("assets/totalXlogotrans.png")),
    );
  }
}
