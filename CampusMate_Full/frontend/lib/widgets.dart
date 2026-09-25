import 'package:flutter/material.dart';

class GradientHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;

  const GradientHeader({super.key, required this.title, required this.subtitle, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondaryContainer],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final String name;
  final String url;
  final double size;

  const Avatar({super.key, required this.name, this.url = '', this.size = 44});

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
      child: url.isEmpty ? Text(initial, style: TextStyle(fontWeight: FontWeight.bold, fontSize: size * .38)) : null,
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const EmptyState({super.key, required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 58, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
