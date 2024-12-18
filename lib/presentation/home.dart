import 'package:auth_and_firestore/data/models/user.dart';
import 'package:auth_and_firestore/data/repositories/auth.dart';
import 'package:auth_and_firestore/data/repositories/firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _userModel;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId != null) {
      final userData =
          await context.read<FirestoreRepository>().getUserData(userId);
      setState(() {
        _userModel = userData;
      });
    }
  }

  Future<void> _logout() async {
    await context.read<AuthRepository>().signOut();
    Navigator.pushReplacement(
      context,
      // Add LoginSCreen
      MaterialPageRoute(builder: (context) => const Placeholder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: _userModel == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${_userModel!.name}'),
                  Text('Alter: ${_userModel!.age}'),
                  if (_userModel!.createdAt != null)
                    Text('Erstellt am: ${_userModel!.createdAt}'),
                ],
              ),
      ),
    );
  }
}
