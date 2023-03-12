import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

class LabeledStatTable extends StatelessWidget {
  final List<LabeledStatRow> rows;

  const LabeledStatTable({Key? key, required this.rows}) : super(key: key);

  Widget _buildLabel(String label, context) => Expanded(
    child: Center(
      child: Text(
        label,
        style: TextStyles.caption.copyWith(
          color: AppColors.of(context).neutralContent,
        ),
      ),
    ),
  );

  List<Widget> _expandRow(LabeledStatRow row, BuildContext context) {
    return [
      Row(
        children: row.labels
            .map((label) => _buildLabel(label, context))
            .toList(),
      ),
      const SizedBox(height: Insets.xs),
      Row(
        children: row.stats
            .map((stat) => Expanded(child: Center(child: stat)))
            .toList(),
      ),
      const SizedBox(height: Insets.med),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rows.expand((row) => _expandRow(row, context)).toList()
        // Remove final sized box padding.
        ..removeLast(),
    );
  }
}

class LabeledStatRow {
  final List<String> labels;
  final List<Widget> stats;

  const LabeledStatRow({required this.labels, required this.stats})
      : assert(labels.length == stats.length,
            "The number of labels and stats in a row but be equal.");
}
