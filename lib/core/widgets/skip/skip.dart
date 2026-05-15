import 'package:flutter/material.dart';

class Skip extends StatelessWidget {
  final VoidCallback? onPressed;

  const Skip({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed ?? () {},
        child: const Text(
          'Skip',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

