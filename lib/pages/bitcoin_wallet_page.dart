import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BitcoinWalletPage extends StatefulWidget {
  @override
  _BitcoinWalletPageState createState() => _BitcoinWalletPageState();
}

class _BitcoinWalletPageState extends State<BitcoinWalletPage> {
  late Database _database;
  double _balance = 0.0;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _amountController = TextEditingController();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'bitcoin_wallet.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE bitcoin_wallet(id INTEGER PRIMARY KEY, balance REAL)',
        );
      },
      version: 1,
    );
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    final List<Map<String, dynamic>> rows = await _database.query('bitcoin_wallet');
    if (rows.isNotEmpty) {
      setState(() {
        _balance = rows.first['balance'];
      });
    }
  }

  Future<void> _updateBalance(double amount) async {
    await _database.transaction((txn) async {
      await txn.rawUpdate(
        'UPDATE bitcoin_wallet SET balance = ?',
        [_balance + amount],
      );
    });
    _fetchBalance();
  }

  Future<void> _buyBitcoin() async {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) {
      _showErrorDialog('Invalid Amount', 'Please enter a valid positive number.');
      return;
    }

    await _updateBalance(amount);
    _amountController.clear();
  }

  Future<void> _sellBitcoin() async {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) {
      _showErrorDialog('Invalid Amount', 'Please enter a valid positive number.');
      return;
    }
    if (amount > _balance) {
      _showErrorDialog('Insufficient Balance', 'You do not have enough Bitcoin to sell.');
      return;
    }

    await _updateBalance(-amount);
    _amountController.clear();
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context as BuildContext,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitcoin Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Balance: $_balance BTC',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 32.0),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _buyBitcoin,
                  icon: Icon(Icons.arrow_upward),
                  label: Text('Buy Bitcoin'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton.icon(
                  onPressed: _sellBitcoin,
                  icon: Icon(Icons.arrow_downward),
                  label: Text('Sell Bitcoin'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
