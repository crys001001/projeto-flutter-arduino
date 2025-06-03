import 'package:flutter/material.dart';
import 'package:flutter_application/src/components/logs_details_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  String selectedAction = 'Todos';
  String searchQuery = '';
  String userSearch = '';
  final TextEditingController userSearchController = TextEditingController();

  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> logs = [];

  final String baseUrl = 'http://192.168.0.10:3000/admin';

  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchLogs();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.10:3000/usuarios'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          users = data.cast<Map<String, dynamic>>();
        });
      } else {
        print('Erro ao buscar usuários: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar usuários: $e');
    }
  }

  Future<void> fetchLogs() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.10:3000/logs'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          logs = data.cast<Map<String, dynamic>>();
        });
      } else {
        print('Erro ao buscar logs: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar logs: $e');
    }
  }

  Future<void> deleteUser(String userEmail) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.0.10:3000/deletar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': userEmail}),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          users.removeWhere((u) => u['email'] == userEmail);
        });
        fetchLogs(); // Atualize os logs após exclusão
      } else {
        print('Erro ao excluir usuário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao excluir usuário: $e');
    }
  }

  List<Map<String, dynamic>> getFilteredLogs() {
    return logs.where((log) {
      final acao =
          (log['tipo_acao'] ?? log['acao'] ?? '').toString().toLowerCase();
      final usuario =
          (log['nome_usuario'] ?? log['usuario'] ?? '')
              .toString()
              .toLowerCase();

      final matchesAction = selectedAction == 'Todos' || acao == selectedAction;
      final matchesSearch = usuario.contains(searchQuery.toLowerCase());
      return matchesAction && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(height: 4, color: Colors.blue),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Auditoria',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TabBarHeader(
            selectedTab: selectedTab,
            onTabChange: (index) => setState(() => selectedTab = index),
          ),
          Expanded(child: selectedTab == 0 ? buildUserTab() : buildLogsTab()),
          Container(height: 4, color: Colors.blue),
        ],
      ),
    );
  }

  Widget buildUserTab() {
    final filteredUsers =
        users.where((user) {
          return (user['nome'] ?? user['name'] ?? '')
              .toString()
              .toLowerCase()
              .contains(userSearch.toLowerCase());
        }).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: userSearchController,
            decoration: InputDecoration(
              hintText: 'Pesquisar usuários',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                userSearch = value;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (_, index) {
                final user = filteredUsers[index];
                return ListTile(
                  title: Text(
                    user['nome'] ?? user['name'] ?? 'Usuário sem nome',
                  ),
                  subtitle: Text(user['email'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Confirmar exclusão'),
                              content: Text(
                                'Tem certeza que deseja excluir este usuário?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    'Excluir',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        await deleteUser(user['email']);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Usuário excluído!')),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLogsTab() {
    final filteredLogs = getFilteredLogs();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar registros',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() => searchQuery = value),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  ['Todos', 'inseriu', 'editou', 'excluiu'].map((action) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedAction == action
                                  ? Colors.blueAccent
                                  : Colors.grey[200],
                          foregroundColor:
                              selectedAction == action
                                  ? Colors.white
                                  : Colors.black,
                          elevation: 0,
                          minimumSize: const Size(80, 40),
                        ),
                        onPressed:
                            () => setState(() => selectedAction = action),
                        child: Text(action),
                      ),
                    );
                  }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLogs.length,
              itemBuilder: (_, index) {
                final log = filteredLogs[index];
                return ListTile(
                  leading: Icon(Icons.history),
                  title: Text(
                    '${log['nome_usuario'] ?? log['usuario'] ?? 'null'} '
                    '${(log['tipo_acao'] ?? log['acao'] ?? '').toString()} - '
                    '${log['data_hora']?.toString().substring(0, 16) ?? ''}',
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => LogDetailsDialog(log: log),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TabBarHeader extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChange;

  const TabBarHeader({
    super.key,
    required this.selectedTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [buildTab('Usuários', 0), buildTab('Logs', 1)]);
  }

  Widget buildTab(String label, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChange(index),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blue : Colors.grey,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
