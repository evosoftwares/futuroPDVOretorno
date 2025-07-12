import 'package:cloud_firestore/cloud_firestore.dart';

class Wallet {
  final double balance;
  final String currency;
  final Timestamp lastTransactionAt;

  Wallet({
    required this.balance,
    required this.currency,
    required this.lastTransactionAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: (json['balance'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'BRL',
      lastTransactionAt: json['lastTransactionAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'currency': currency,
      'lastTransactionAt': lastTransactionAt,
    };
  }
} 