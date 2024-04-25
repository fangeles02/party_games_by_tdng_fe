import 'package:flutter/material.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({super.key, this.prompt});

  final String? prompt;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(
            width: 15,
          ),
          Text(
            prompt ?? "Please wait",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
