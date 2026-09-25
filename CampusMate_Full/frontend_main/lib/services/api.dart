import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static const baseUrl='https://campusmate-demo-app-szj4.vercel.app/api';
  static Future<Map<String,String>> headers() async { final p=await SharedPreferences.getInstance(); final t=p.getString('token'); return {'Content-Type':'application/json',if(t!=null&&t.isNotEmpty)'Authorization':'Bearer $t'}; }
  static Future<dynamic> _send(http.Response r) async { dynamic d; try{d=r.body.isEmpty?null:jsonDecode(r.body);}catch(_){d={'message':r.body};} if(r.statusCode>=200&&r.statusCode<300)return d??{'success':true}; throw Exception(d is Map&&d['message']!=null?d['message']:'Request failed (${r.statusCode})');}
  static Future<dynamic> get(String path) async=>_send(await http.get(Uri.parse('$baseUrl$path'),headers:await headers()));
  static Future<dynamic> post(String path,[Map<String,dynamic>? body]) async=>_send(await http.post(Uri.parse('$baseUrl$path'),headers:await headers(),body:body==null?null:jsonEncode(body)));
  static Future<dynamic> put(String path,[Map<String,dynamic>? body]) async=>_send(await http.put(Uri.parse('$baseUrl$path'),headers:await headers(),body:body==null?null:jsonEncode(body)));
  static Future<dynamic> patch(String path,[Map<String,dynamic>? body]) async=>_send(await http.patch(Uri.parse('$baseUrl$path'),headers:await headers(),body:body==null?null:jsonEncode(body)));
  static Future<dynamic> del(String path) async=>_send(await http.delete(Uri.parse('$baseUrl$path'),headers:await headers()));
  static Future<String> upload(File file) async { final h=await headers();h.remove('Content-Type');final req=http.MultipartRequest('POST',Uri.parse('$baseUrl/upload'));req.headers.addAll(h);req.files.add(await http.MultipartFile.fromPath('file',file.path));final r=await http.Response.fromStream(await req.send());final d=await _send(r);return '${d['url']}';}
  static Future<void> save(dynamic response) async {final p=await SharedPreferences.getInstance();await p.setString('token','${response['token']}');await p.setString('user',jsonEncode(response['user']));}
  static Future<void> logout() async {final p=await SharedPreferences.getInstance();await p.remove('token');await p.remove('user');}
}
