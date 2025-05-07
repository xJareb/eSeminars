import 'package:flutter/material.dart';

typedef PageChangeCallback = Future<void> Function(int newPage);

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int pageSize;
  final PageChangeCallback onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalItems,
    required this.pageSize,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalItems / pageSize).ceil();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: currentPage > 0
                ? () => onPageChanged(currentPage - 1)
                : null,
            child: const Icon(Icons.navigate_before),
          ),
          const SizedBox(width: 10),
          Text((currentPage + 1).toString(), style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: (currentPage + 1) < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
            child: const Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}
