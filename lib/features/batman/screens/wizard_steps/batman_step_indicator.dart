import 'package:flutter/material.dart';

class BatmanStepIndicator extends StatelessWidget {
  final List<String> titles;
  final int currentStep;
  final void Function(int) onTap;

  const BatmanStepIndicator({
    super.key,
    required this.titles,
    required this.currentStep,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: List.generate(titles.length, (i) {
          final isDone = i < currentStep;
          final isCurrent = i == currentStep;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone || isCurrent ? Colors.amber : Colors.grey.shade800,
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check, size: 16, color: Colors.black)
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCurrent ? Colors.black : Colors.grey,
                            ),
                          ),
                  ),
                ),
                if (i < titles.length - 1)
                  Container(
                    width: 20,
                    height: 2,
                    color: isDone ? Colors.amber : Colors.grey.shade700,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
