class Wallet {
  final int id;
  final String address;
  double balance;
  final String symbol;
  List<WalletTransaction> transactions = [];

  Wallet({
    required this.id,
    required this.address,
    required this.balance,
    required this.symbol, required List<WalletTransaction> transactions,
  });

  void addBalance(double amount) {
    balance += amount;
    transactions.add(WalletTransaction(type: 'buy', amount: amount, date: DateTime.now()));
  }

  void removeBalance(double amount) {
    if (balance >= amount) {
      balance -= amount;
      transactions.add(WalletTransaction(type: 'sell', amount: amount, date: DateTime.now()));
    } else {
      print('Insufficient balance');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'balance': balance,
      'symbol': symbol,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map['id'],
      address: map['address'],
      balance: map['balance'].toDouble(),
      symbol: map['symbol'], transactions: [],
    );
  }
}

class WalletTransaction {
  final String type;
  final double amount;
  final DateTime date;

  WalletTransaction({
    required this.type,
    required this.amount,
    required this.date,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      type: json['type'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}

