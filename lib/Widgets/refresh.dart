import 'package:flutter/material.dart';

class Refresh extends StatelessWidget {
  final VoidCallback onRefresh;
  final bool isStopped;
  const Refresh(this.onRefresh, this.isStopped ,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Oppdater GPS'),
      onPressed: isStopped ? null : () {
        onRefresh();
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
        primary: Colors.grey,
      ),
    );
  }
}
