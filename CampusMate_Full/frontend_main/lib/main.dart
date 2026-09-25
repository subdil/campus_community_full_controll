import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';
import 'services/api.dart';
import 'screens/auth.dart';
import 'screens/student.dart';
import 'screens/admin.dart';
import 'services/update_service.dart';

void main()=>runApp(const CampusMateApp());

class CampusMateApp extends StatelessWidget{
 const CampusMateApp({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(
  debugShowCheckedModeBanner:false,title:'CampusMate',
  theme:ThemeData(useMaterial3:true,brightness:Brightness.light,colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF5B5FEF)),scaffoldBackgroundColor:const Color(0xFFF7F7FC),inputDecorationTheme:const InputDecorationTheme(filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(16)),borderSide:BorderSide.none))),
  home:const Gate());
}
class Gate extends StatefulWidget{const Gate({super.key});@override State<Gate> createState()=>_GateState();}
class _GateState extends State<Gate>{
 User? user;bool loading=true;bool blocked=false;
 @override void initState(){super.initState();boot();}
 Future<void> boot()async{final p=await SharedPreferences.getInstance();final s=p.getString('user');if(s!=null){try{user=User.fromJson(jsonDecode(s));}catch(_){await Api.logout();}}setState(()=>loading=false);WidgetsBinding.instance.addPostFrameCallback((_)async{if(!mounted)return;if(await UpdateService.check(context))setState(()=>blocked=true);});}
 @override Widget build(BuildContext c){if(loading)return const Scaffold(body:Center(child:CircularProgressIndicator()));if(blocked)return const Scaffold(body:Center(child:Text('Update required to continue')));if(user==null)return const StudentLogin();return user!.role=='admin'?AdminShell(user:user!):StudentShell(user:user!);}
}
