import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api.dart';
import 'home.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      _message('Enter email and password');
      return;
    }
    setState(() => loading = true);
    try {
      final result = await Api.post('/auth/login', {
        'email': email.text.trim(),
        'password': password.text,
      });
      await Api.save(result);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => Home(user: User.fromJson(Map<String, dynamic>.from(result['user'])))),
        (_) => false,
      );
    } catch (e) {
      if (mounted) _message(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    return _LoginShell(
      child: Column(
        children: [
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.mail_outline), labelText: 'Student email'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: password,
            obscureText: hide,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline),
              labelText: 'Password',
              suffixIcon: IconButton(
                onPressed: () => setState(() => hide = !hide),
                icon: Icon(hide ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: loading ? null : go,
              child: loading ? const CircularProgressIndicator() : const Text('Enter Campus'),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Register())),
            child: const Text('Create student account'),
          ),
        ],
      ),
    );
  }
}

class _LoginShell extends StatelessWidget {
  final Widget child;
  const _LoginShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 470),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.school_rounded, size: 42),
                  const SizedBox(height: 24),
                  const Text('STUDENT SPACE', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  const Text('Sign in to your student space.'),
                  const SizedBox(height: 28),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
