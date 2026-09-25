import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api.dart';
import 'admin_home.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});
  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  bool hide = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> go() async {
    if (email.text.trim().isEmpty || password.text.isEmpty) return;
    setState(() => loading = true);
    try {
      final result = await Api.post('/auth/admin-login', {
        'email': email.text.trim(),
        'password': password.text,
      });
      await Api.save(result);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => AdminHome(user: User.fromJson(Map<String, dynamic>.from(result['user'])))),
        (_) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  InputDecoration decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11111E),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 470),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(22)),
                    child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 24),
                  const Text('ADMIN CONSOLE', style: TextStyle(color: Colors.white70, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Administrator sign in', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('Restricted access for CampusMate administrators.', style: TextStyle(color: Colors.white60)),
                  const SizedBox(height: 28),
                  TextField(controller: email, style: const TextStyle(color: Colors.white), decoration: decoration('Admin email', Icons.mail_outline)),
                  const SizedBox(height: 14),
                  TextField(
                    controller: password,
                    style: const TextStyle(color: Colors.white),
                    obscureText: hide,
                    decoration: decoration('Admin password', Icons.lock_outline).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => hide = !hide),
                        icon: Icon(hide ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: loading ? null : go,
                      style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                      child: loading ? const CircularProgressIndicator() : const Text('Open control center'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
