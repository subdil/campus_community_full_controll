import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api.dart';
import '../widgets.dart';
import 'chat.dart';

class People extends StatefulWidget {
  final User user;
  const People({super.key, required this.user});
  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  final query = TextEditingController();
  List<dynamic> people = [];

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  Future<void> search(String value) async {
    if (value.trim().isEmpty) {
      setState(() => people = []);
      return;
    }
    try {
      final result = await Api.get('/users/search?q=${Uri.encodeQueryComponent(value.trim())}');
      if (mounted) setState(() => people = List<dynamic>.from(result['users'] ?? []));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GradientHeader(title: 'Meet the campus', subtitle: 'Find classmates, friends and creators'),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: query,
            onChanged: search,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by name or email', filled: true),
          ),
        ),
        Expanded(
          child: people.isEmpty
              ? const EmptyState(icon: Icons.person_search, title: 'Search for someone', text: 'Type a name or email to start a conversation.')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: people.length,
                  itemBuilder: (context, index) {
                    final person = Map<String, dynamic>.from(people[index]);
                    final id = '${person['_id'] ?? person['id'] ?? ''}';
                    final name = '${person['name'] ?? 'Student'}';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: Avatar(name: name, url: '${person['profilePic'] ?? ''}'),
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          subtitle: Text('${person['bio'] ?? person['email'] ?? ''}'),
                          trailing: const Icon(Icons.chat_bubble_outline),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Chat(user: widget.user, directUserId: id, title: name)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
