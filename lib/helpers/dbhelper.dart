// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_financeapp/dto/wallet_model.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  String walletTable = 'wallet_table';
  String colId = 'id';
  String colAddress = 'address';
  String colBalance = 'balance';
  String colSymbol = 'symbol';
  String colTransactions = 'transactions'; // Tambahkan kolom transactions

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'wallets.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $walletTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colAddress TEXT NOT NULL,
        $colBalance REAL NOT NULL,
        $colSymbol TEXT NOT NULL,
        $colTransactions TEXT
      )
    ''');
  }

  Future<List<Wallet>> getWallets() async {
    final db = await database;
    final walletMaps = await db!.query(walletTable);
    return List.generate(walletMaps.length, (i) {
      List<WalletTransaction> transactions = [];
      if (walletMaps[i][colTransactions] != null) {
        transactions = (jsonDecode(walletMaps[i][colTransactions] as String) as List)
            .map((transactionData) => WalletTransaction.fromJson(transactionData))
            .toList();
      }
      return Wallet(
        id: walletMaps[i][colId] as int,
        address: walletMaps[i][colAddress].toString(),
        balance: walletMaps[i][colBalance] as double,
        symbol: walletMaps[i][colSymbol].toString(),
        transactions: transactions,
      );
    });
  }

  Future<int> insertWallet(Wallet wallet) async {
    final db = await database;
    return await db!.insert(walletTable, {
      colAddress: wallet.address,
      colBalance: wallet.balance,
      colSymbol: wallet.symbol,
      colTransactions: wallet.transactions.isNotEmpty
          ? jsonEncode(wallet.transactions.map((tx) => tx.toJson()).toList())
          : null,
    });
  }

  Future<int> updateWallet(Wallet wallet) async {
    final db = await database;
    return await db!.update(
      walletTable,
      {
        colAddress: wallet.address,
        colBalance: wallet.balance,
        colSymbol: wallet.symbol,
        colTransactions: wallet.transactions.isNotEmpty
            ? jsonEncode(wallet.transactions.map((tx) => tx.toJson()).toList())
            : null,
      },
      where: '$colId = ?',
      whereArgs: [wallet.id],
    );
  }

  Future<int> deleteWallet(int id) async {
    final db = await database;
    return await db!.delete(
      walletTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<Wallet?> findWalletByAddress(String address) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db!.query(
      walletTable,
      where: '$colAddress = ?',
      whereArgs: [address],
    );
    if (result.isEmpty) {
      return null;
    }
    return Wallet(
      id: result.first[colId] as int,
      address: result.first[colAddress].toString(),
      balance: result.first[colBalance] as double,
      symbol: result.first[colSymbol].toString(),
      transactions: (jsonDecode(result.first[colTransactions] as String) as List)
          .map((transactionData) => WalletTransaction.fromJson(transactionData))
          .toList(),
    );
  }

  getProfile() {}

  updateProfile(Map<String, String> profile) {}
}
