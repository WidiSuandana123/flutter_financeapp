import 'package:flutter/material.dart';

class ImportWalletPage extends StatefulWidget {
  const ImportWalletPage({Key? key}) : super(key: key);

  @override
  _ImportWalletPageState createState() => _ImportWalletPageState();
}

class _ImportWalletPageState extends State<ImportWalletPage> {
  final _seedPhraseController = TextEditingController();

  @override
  void dispose() {
    _seedPhraseController.dispose(); // Membuang TextEditingController saat tidak digunakan
    super.dispose();
  }

  void _importWallet() {
    final jjjj = _seedPhraseController.text.trim(); // Mengambil nilai seed phrase dari TextEditingController
    // Logika untuk mengimport dompet dengan seed phrase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your seed phrase to import your existing wallet',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _seedPhraseController, // Menggunakan TextEditingController pada TextField
              decoration: const InputDecoration(
                labelText: 'Seed Phrase',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _importWallet,
              child: const Text('Import Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}