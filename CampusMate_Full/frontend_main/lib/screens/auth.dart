import 'package:flutter/material.dart';
import '../models/user.dart';import '../services/api.dart';import 'student.dart';import 'admin.dart';

class StudentLogin extends StatefulWidget{const StudentLogin({super.key});@override State<StudentLogin> createState()=>_StudentLoginState();}
class _StudentLoginState extends State<StudentLogin>{final e=TextEditingController(),p=TextEditingController();bool loading=false;
 Future<void> go()async{if(e.text.trim().isEmpty||p.text.isEmpty)return msg('Enter email and password');setState(()=>loading=true);try{final r=await Api.post('/auth/login',{'email':e.text.trim(),'password':p.text});await Api.save(r);if(mounted)Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>StudentShell(user:User.fromJson(r['user']))));}catch(x){if(mounted)msg(x.toString().replaceFirst('Exception: ',''));}finally{if(mounted)setState(()=>loading=false);}}
 void msg(String s)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(s)));
 @override Widget build(BuildContext c)=>AuthFrame(title:'Welcome back 👋',subtitle:'Your campus, your communities, your people.',icon:Icons.school,accent:const Color(0xFF5B5FEF),children:[
  TextField(controller:e,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Student email',prefixIcon:Icon(Icons.email_outlined))),
  const SizedBox(height:12),TextField(controller:p,obscureText:true,decoration:const InputDecoration(labelText:'Password',prefixIcon:Icon(Icons.lock_outline))),
  const SizedBox(height:20),SizedBox(width:double.infinity,height:54,child:FilledButton(onPressed:loading?null:go,child:loading?const CircularProgressIndicator():const Text('Enter CampusMate'))),
  const SizedBox(height:8),TextButton(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const RegisterPage())),child:const Text('Create student account')),
  TextButton.icon(onPressed:()=>Navigator.pushReplacement(c,MaterialPageRoute(builder:(_)=>const AdminLogin())),icon:const Icon(Icons.admin_panel_settings),label:const Text('Admin portal'))
 ]);}
class AdminLogin extends StatefulWidget{const AdminLogin({super.key});@override State<AdminLogin> createState()=>_AdminLoginState();}
class _AdminLoginState extends State<AdminLogin>{final e=TextEditingController(),p=TextEditingController();bool loading=false;
 Future<void> go()async{if(e.text.trim().isEmpty||p.text.isEmpty)return msg('Enter admin credentials');setState(()=>loading=true);try{final r=await Api.post('/auth/admin-login',{'email':e.text.trim(),'password':p.text});await Api.save(r);if(mounted)Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>AdminShell(user:User.fromJson(r['user']))));}catch(x){if(mounted)msg(x.toString().replaceFirst('Exception: ',''));}finally{if(mounted)setState(()=>loading=false);}}
 void msg(String s)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(s)));
 @override Widget build(BuildContext c)=>AuthFrame(title:'Admin Control Center',subtitle:'Secure moderation & campus management portal.',icon:Icons.shield_rounded,accent:const Color(0xFF101828),children:[
  Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xFF101828),borderRadius:BorderRadius.circular(16)),child:const Row(children:[Icon(Icons.verified_user,color:Colors.white),SizedBox(width:10),Expanded(child:Text('Admin accounts are created by the system. Student registration is disabled here.',style:TextStyle(color:Colors.white)))])),
  const SizedBox(height:18),TextField(controller:e,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(labelText:'Admin email',prefixIcon:Icon(Icons.alternate_email))),
  const SizedBox(height:12),TextField(controller:p,obscureText:true,decoration:const InputDecoration(labelText:'Admin password',prefixIcon:Icon(Icons.key_outlined))),
  const SizedBox(height:20),SizedBox(width:double.infinity,height:54,child:FilledButton(onPressed:loading?null:go,style:FilledButton.styleFrom(backgroundColor:const Color(0xFF101828)),child:loading?const CircularProgressIndicator():const Text('Open Admin Dashboard'))),
  TextButton.icon(onPressed:()=>Navigator.pushReplacement(c,MaterialPageRoute(builder:(_)=>const StudentLogin())),icon:const Icon(Icons.arrow_back),label:const Text('Back to student login'))
 ]);}
class AuthFrame extends StatelessWidget{final String title,subtitle;final IconData icon;final Color accent;final List<Widget> children;const AuthFrame({super.key,required this.title,required this.subtitle,required this.icon,required this.accent,required this.children});
 @override Widget build(BuildContext c)=>Scaffold(body:Container(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[accent.withOpacity(.12),Colors.white,accent.withOpacity(.05)])),child:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:460),child:Card(elevation:0,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(30)),child:Padding(padding:const EdgeInsets.all(28),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
 CircleAvatar(radius:30,backgroundColor:accent,child:Icon(icon,color:Colors.white,size:30)),const SizedBox(height:22),Text(title,style:const TextStyle(fontSize:30,fontWeight:FontWeight.w800)),const SizedBox(height:8),Text(subtitle,style:TextStyle(color:Colors.grey.shade700,fontSize:15)),const SizedBox(height:28),...children
 ])))))));
}
class RegisterPage extends StatefulWidget{const RegisterPage({super.key});@override State<RegisterPage> createState()=>_RegisterPageState();}
class _RegisterPageState extends State<RegisterPage>{final n=TextEditingController(),e=TextEditingController(),p=TextEditingController();bool loading=false;
 Future<void> go()async{if(n.text.trim().isEmpty||e.text.trim().isEmpty||p.text.length<6)return msg('Enter all details. Password must be 6+ characters.');setState(()=>loading=true);try{final r=await Api.post('/auth/register',{'name':n.text.trim(),'email':e.text.trim(),'password':p.text});await Api.save(r);if(mounted)Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>StudentShell(user:User.fromJson(r['user']))),(_)=>false);}catch(x){if(mounted)msg(x.toString().replaceFirst('Exception: ',''));}finally{if(mounted)setState(()=>loading=false);}}
 void msg(String s)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(s)));
 @override Widget build(BuildContext c)=>AuthFrame(title:'Join CampusMate',subtitle:'Create your student identity in seconds.',icon:Icons.person_add_alt_1,accent:const Color(0xFF5B5FEF),children:[
  TextField(controller:n,decoration:const InputDecoration(labelText:'Full name',prefixIcon:Icon(Icons.person_outline))),const SizedBox(height:12),
  TextField(controller:e,decoration:const InputDecoration(labelText:'Email',prefixIcon:Icon(Icons.email_outlined))),const SizedBox(height:12),
  TextField(controller:p,obscureText:true,decoration:const InputDecoration(labelText:'Password',prefixIcon:Icon(Icons.lock_outline))),const SizedBox(height:20),
  SizedBox(width:double.infinity,height:52,child:FilledButton(onPressed:loading?null:go,child:loading?const CircularProgressIndicator():const Text('Create account'))),
  Center(child:TextButton(onPressed:()=>Navigator.pop(c),child:const Text('Already have an account? Login')))
 ]);}
}
