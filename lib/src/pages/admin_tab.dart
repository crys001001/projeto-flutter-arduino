import 'package:flutter/material.dart';

class AdminTabScreen extends StatefulWidget {
  const AdminTabScreen({Key? key}) : super(key: key);

  @override
  State<AdminTabScreen> createState() => _AdminTabScreenState();
}

class _AdminTabScreenState extends State<AdminTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Usuários'),
    const Tab(text: 'Logs'),
    const Tab(text: 'Configurações'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área do Admin'),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Cada aba pode ser um widget separado que você vai criar depois
          Center(child: Text('Gerenciamento de Usuários')),
          Center(child: Text('Logs de Acesso')),
          Center(child: Text('Configurações')),
        ],
      ),
    );
  }
}
