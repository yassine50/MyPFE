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

  /// Approximate fixed exchange rates relative to EUR (1 EUR = X currency)
  static const Map<String, double> _rates = {
    'EUR': 1.0,
    'RON': 4.97,
    'USD': 1.08,
    'GBP': 0.86,
    'CHF': 0.97,
    'SEK': 11.50,
    'NOK': 11.70,
    'DKK': 7.46,
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
  static String get code => codeNotifier.value;

  /// Convert a EUR-based amount to the currently selected currency
  static double convert(num eurAmount) {
    final rate = _rates[codeNotifier.value] ?? 1.0;
    return eurAmount * rate;
  }

  static String format(num eurAmount) {
    final converted = convert(eurAmount);
    // For 'lei' place symbol after the number
    if (codeNotifier.value == 'RON') {
      return '${converted.toStringAsFixed(0)} lei';
    }
    return '$symbol${converted.toStringAsFixed(0)}';
  }

  static String formatWithDecimals(num eurAmount) {
    final converted = convert(eurAmount);
    if (codeNotifier.value == 'RON') {
      return '${converted.toStringAsFixed(2)} lei';
    }
    return '$symbol${converted.toStringAsFixed(2)}';
  }
}
