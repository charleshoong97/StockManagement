import 'package:flutter/material.dart';

Widget scannerButton(
    {required BuildContext context,
    required Color color,
    required void Function() func,
    required String label}) {
  return Ink(
    width: 130,
    height: 130,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: color,
    ),
    child: InkWell(
      onTap: func,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.document_scanner,
            size: 40,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          )
        ],
      ),
    ),
  );
}
