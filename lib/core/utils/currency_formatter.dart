import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CurrencyFormatter {
  static final ValueNotifier<String> symbolNotifier = ValueNotifier<String>('€');
  static final ValueNotifier<String> codeNotifier = ValueNotifier<String>('EUR');

  static final Map<String, String> _currencySymbols = {
    'EUR': '€',
    'RON': 'lei',
    'USD': '\$',
    'GBP': '£',
    'CHF': 'CHF',
    'SEK': 'kr',
    'NOK': 'kr',
    'DKK': 'kr',
  };

  static void init() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        FirebaseDatabase.instance.ref('users/${user.uid}/currency').onValue.listen((event) {
          if (event.snapshot.exists && event.snapshot.value != null) {
            final code = event.snapshot.value as String;
            codeNotifier.value = code;
            symbolNotifier.value = _currencySymbols[code] ?? '€';
          }
        });
      } else {
        symbolNotifier.value = '€';
        codeNotifier.value = 'EUR';
      }
    });
  }

  static String get symbol => symbolNotifier.value;
  
  static String format(num amount) {
    return '$symbol${amount.toStringAsFixed(0)}';
  }

  static String formatWithDecimals(num amount) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}
