import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api.dart';
import 'admin.dart';
import 'admin_login.dart';

class AdminHome extends StatefulWidget {
  final User user;
  const AdminHome({super.key, required this.user});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int index = 0;

  Future<void> logout() async {
    await Api.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AdminLogin()),
      (_) => false,
    );
  }

  String get title {
    const titles = ['Control center', 'Users', 'Communities', 'Posts', 'Messages', 'App update'];
    return titles[index];
  }

  void select(int value) {
    setState(() => index = value);
    Navigator.pop(context);
  }

  Widget drawerItem(int value, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: index == value,
      onTap: () => select(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151525),
        foregroundColor: Colors.white,
        title: Text(title),
        actions: [IconButton(onPressed: logout, icon: const Icon(Icons.logout))],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 180,
              color: const Color(0xFF151525),
              padding: const EdgeInsets.all(22),
              alignment: Alignment.bottomLeft,
              child: const Text(
                'CAMPUSMATE\nADMIN',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
            ),
            drawerItem(0, Icons.dashboard_rounded, 'Overview'),
            drawerItem(1, Icons.people_rounded, 'Users'),
            drawerItem(2, Icons.groups_rounded, 'Communities'),
            drawerItem(3, Icons.article_rounded, 'Posts'),
            drawerItem(4, Icons.forum_rounded, 'Messages'),
            drawerItem(5, Icons.system_update_rounded, 'App update'),
          ],
        ),
      ),
      body: Admin(user: widget.user, section: index),
    );
  }
}
