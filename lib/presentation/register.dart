import 'package:auth_and_firestore/data/models/user.dart';
import 'package:auth_and_firestore/data/repositories/auth.dart';
import 'package:auth_and_firestore/data/repositories/firestore.dart';
import 'package:auth_and_firestore/presentation/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _errorMessage = '';

  Future<void> _register() async {
    final firestoreRepo = context.read<FirestoreRepository>();
    final userId = context.read<AuthRepository>().currentUser?.uid;

    if (userId == null) return;

    try {
      final user = User(
        id: userId,
        name: _nameController.text,
        age: int.parse(_ageController.text),
      );
      await firestoreRepo.createUserDoc(userId, user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Speichern der Daten: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Benutzerinformationen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Alter'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Speichern'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
