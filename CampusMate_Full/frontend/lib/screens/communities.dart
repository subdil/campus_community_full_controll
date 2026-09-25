import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api.dart';
import '../widgets.dart';
import 'chat.dart';

class Communities extends StatefulWidget {
  final User user;
  const Communities({super.key, required this.user});

  @override
  State<Communities> createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  final query = TextEditingController();
  List<dynamic> communities = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final result = await Api.get('/communities?q=${Uri.encodeQueryComponent(query.text.trim())}');
      if (mounted) setState(() => communities = List<dynamic>.from(result['communities'] ?? []));
    } catch (e) {
      if (mounted) _message(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> createCommunity() async {
    final name = TextEditingController();
    final description = TextEditingController();
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create community'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: 'Community name')),
              TextField(controller: description, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                if (name.text.trim().isEmpty) return;
                try {
                  await Api.post('/communities', {'name': name.text.trim(), 'description': description.text.trim()});
                  if (dialogContext.mounted) Navigator.pop(dialogContext, true);
                } catch (e) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
    name.dispose();
    description.dispose();
    if (created == true) await load();
  }

  Future<void> join(String id) async {
    try {
      final result = await Api.post('/communities/$id/join', {});
      if (mounted) _message('${result['message'] ?? 'Request sent'}');
    } catch (e) {
      if (mounted) _message(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientHeader(
          title: 'Find your people',
          subtitle: 'Communities built by students',
          action: IconButton(onPressed: createCommunity, icon: const Icon(Icons.add_circle_outline)),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: query,
            onChanged: (_) => load(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search communities',
              filled: true,
              suffixIcon: loading ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()) : null,
            ),
          ),
        ),
        Expanded(
          child: communities.isEmpty
              ? const EmptyState(icon: Icons.groups_2_outlined, title: 'No communities yet', text: 'Create one and bring your people together.')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: communities.length,
                  itemBuilder: (context, index) {
                    final item = Map<String, dynamic>.from(communities[index]);
                    final id = '${item['_id'] ?? ''}';
                    final name = '${item['name'] ?? ''}';
                    final description = '${item['description'] ?? ''}';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(14),
                          leading: const CircleAvatar(child: Icon(Icons.groups)),
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          subtitle: Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: OutlinedButton(onPressed: () => join(id), child: const Text('Join')),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Chat(user: widget.user, communityId: id, title: name)),
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
