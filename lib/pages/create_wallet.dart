import 'package:flutter/material.dart';
import 'dashboard.dart'; // Sesuaikan dengan path yang benar ke dashboard.dart

class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({Key? key}) : super(key: key);

  @override
  _CreateWalletPageState createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordValid = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createWallet(BuildContext context) {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Logika sederhana untuk membuat dompet baru dengan password
    if (password.isNotEmpty && password == confirmPassword) {
      // Anggap membuat dompet baru berhasil jika password valid
      setState(() {
        _isPasswordValid = true;
      });
      
      // Navigasi ke halaman Dashboard setelah membuat dompet berhasil
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
    } else {
      // Anggap membuat dompet baru gagal jika password tidak valid
      setState(() {
        _isPasswordValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set a secure password for your new wallet',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _createWallet(context),
              child: const Text('Create Wallet'),
            ),
            const SizedBox(height: 20.0),
            if (_isPasswordValid)
              const Text(
                'New wallet created successfully!',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16.0,
                ),
              )
            else if (!_isPasswordValid)
              const Text(
                'Failed to create wallet. Please check your password.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                ),
              )
          ],
        ),
      ),
    );
  }
}
