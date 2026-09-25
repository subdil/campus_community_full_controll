import 'package:flutter/material.dart';
import 'admin_login.dart';
import 'login.dart';
import 'register.dart';

class Entry extends StatelessWidget {
  const Entry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5B5FEF), Color(0xFF8C5CF6)],
                  ),
                ),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 38),
              ),
              const SizedBox(height: 22),
              Text(
                'CampusMate',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                'Your campus. Your people. Your space.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 35),
              _card(
                context,
                Icons.school_rounded,
                'Student space',
                'Posts, people, communities & chats',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Login())),
              ),
              const SizedBox(height: 14),
              _card(
                context,
                Icons.admin_panel_settings_rounded,
                'Admin control',
                'Moderation, users, communities & updates',
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminLogin())),
                dark: true,
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Register())),
                  child: const Text('New student? Create an account'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool dark = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: dark ? const Color(0xFF17172A) : Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 22, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: dark ? Colors.white12 : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: dark ? Colors.white : Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: dark ? Colors.white : null)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: dark ? Colors.white70 : null)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: dark ? Colors.white : Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
