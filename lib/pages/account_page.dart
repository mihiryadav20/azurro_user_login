import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();

  bool _loading = true;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentUser?.id;
      final email = supabase.auth.currentUser?.email;
      if (userId == null) throw Exception("User not logged in");

      final data = await supabase.from('user_profiles').select().eq('id', userId).single();
      _firstNameController.text = (data['first_name'] ?? '') as String;
      _lastNameController.text = (data['last_name'] ?? '') as String;
      _dobController.text = (data['date_of_birth'] ?? '') as String;
      _emailController.text = (data['email'] ?? email) as String;  // Fallback to Supabase auth email if not in profile

      print('Email fetched: ${_emailController.text}');  // Debug log
    } on PostgrestException catch (error) {
      _showSnackBar(error.message, isError: true);
    } catch (error) {
      _showSnackBar('Unexpected error occurred', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _updating = true;
    });

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final dob = _dobController.text.trim();
    final email = _emailController.text.trim();
    final user = supabase.auth.currentUser;
    if (user == null) {
      _showSnackBar('User not logged in', isError: true);
      setState(() {
        _updating = false;
      });
      return;
    }

    final updates = {
      'id': user.id,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dob,
      'email': email,
      'updated_at': DateTime.now().toIso8601String(),
    };

    print('Updating profile with: $updates');  // Debug log

    try {
      await supabase.from('user_profiles').upsert(updates);
      _showSnackBar('Successfully updated profile!');
    } on PostgrestException catch (error) {
      _showSnackBar(error.message, isError: true);
    } catch (error) {
      _showSnackBar('Unexpected error occurred', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _updating = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } on AuthException catch (error) {
      _showSnackBar(error.message, isError: true);
    } catch (error) {
      _showSnackBar('Unexpected error occurred', isError: true);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = picked.toLocal().toIso8601String().split('T')[0];
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _dobController,
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: _updating ? null : _updateProfile,
                  child: Text(_updating ? 'Saving...' : 'Update'),
                ),
                const SizedBox(height: 18),
                TextButton(onPressed: _signOut, child: const Text('Sign Out')),
              ],
            ),
    );
  }
}
