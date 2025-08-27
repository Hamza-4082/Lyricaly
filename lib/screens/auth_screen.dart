import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'user';
  bool _isLogin = true;
  bool _busy = false;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;

    setState(() => _busy = true);
    try {
      if (_isLogin) {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(email, password);
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .signup(email, password, _selectedRole);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            if (!_isLogin)
              DropdownButton<String>(
                value: _selectedRole,
                items: const [
                  DropdownMenuItem(value: 'user', child: Text("User")),
                  DropdownMenuItem(value: 'admin', child: Text("Admin")),
                  DropdownMenuItem(
                      value: 'advertiser', child: Text("Advertiser")),
                ],
                onChanged: (v) => setState(() => _selectedRole = v!),
              ),
            const SizedBox(height: 16),
            _busy
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _submit,
              child: Text(_isLogin ? 'Login' : 'Sign Up'),
            ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin
                  ? "Create new account"
                  : "I already have an account"),
            ),
          ],
        ),
      ),
    );
  }
}
