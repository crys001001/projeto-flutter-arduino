import 'package:flutter/material.dart';

class AuditScreen extends StatefulWidget {
  const AuditScreen({Key? key}) : super(key: key);

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  String selectedAction = 'Todos';
  String searchQuery = '';

  final List<Map<String, dynamic>> users = [
    {'id': 1, 'nome': 'Admin1'},
    {'id': 2, 'nome': 'Admin2'},
    {'id': 3, 'nome': 'Admin3'},
  ];

  final List<Map<String, dynamic>> logs = [];

  void deleteUser(int userId) {
    final user = users.firstWhere((u) => u['id'] == userId);
    setState(() {
      users.removeWhere((u) => u['id'] == userId);
      logs.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'usuario': user['nome'],
        'acao': 'excluiu',
        'hora': DateTime.now().toString(),
        'campo': 'usuário',
        'valorAntigo': user['nome'],
        'valorNovo': 'Usuário removido',
      });
    });
  }

  List<Map<String, dynamic>> getFilteredLogs() {
    return logs.where((log) {
      final matchesAction =
          selectedAction == 'Todos' || log['acao'] == selectedAction;
      final matchesSearch = log['usuario'].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesAction && matchesSearch;
    }).toList();
  }

  void showLogDetails(Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Detalhes da Ação'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ID: ${log['id']}'),
                Text('Admin: ${log['usuario']}'),
                Text('Ação: ${log['acao']}'),
                Text('Hora: ${log['hora']}'),
                if (log['acao'] == 'editou') ...[
                  Text('Campo: ${log['campo']}'),
                  Text('Valor antigo: ${log['valorAntigo']}'),
                  Text('Valor novo: ${log['valorNovo']}'),
                ],
                if (log['acao'] == 'excluiu')
                  Text('Item excluído: ${log['valorAntigo']}'),
                if (log['acao'] == 'inseriu') Text('Registro inserido'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fechar'),
              ),
            ],
          ),
    );
  }

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(height: 4, color: Colors.blue), // Borda superior
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
          Container(height: 4, color: Colors.blue), // Borda inferior
        ],
      ),
    );
  }

  Widget buildUserTab() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (_, index) {
        final user = users[index];
        return ListTile(
          title: Text(user['nome']),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => deleteUser(user['id']),
          ),
        );
      },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                ['Todos', 'inseriu', 'editou', 'excluiu'].map((action) {
                  return ElevatedButton(
                    onPressed: () => setState(() => selectedAction = action),
                    child: Text(action),
                  );
                }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLogs.length,
              itemBuilder: (_, index) {
                final log = filteredLogs[index];
                return ListTile(
                  leading: Icon(Icons.history),
                  title: Text(
                    '${log['usuario']} ${log['acao']} - ${log['hora'].toString().substring(0, 16)}',
                  ),
                  onTap: () => showLogDetails(log),
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

  const TabBarHeader({required this.selectedTab, required this.onTabChange});

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
