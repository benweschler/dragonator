import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:flutter/material.dart';

/// A table that builds a uniform label for each of its elements.
class LabeledTable extends StatelessWidget {
  final List<LabeledTableRow> rows;

  /// The alignment of elements within their columns.
  final Alignment elementAlignment;

  /// Whether to add padding between table columns.
  ///
  /// Defaults to only adding padding when elements are not center-aligned.
  final bool addColumnPadding;

  const LabeledTable({
    Key? key,
    required this.rows,
    this.elementAlignment = Alignment.center,
    bool? addColumnSeparator,
  })  : addColumnPadding =
            addColumnSeparator ?? elementAlignment == Alignment.center,
        super(key: key);

  Widget _wrapElement(Widget element) =>
      Expanded(child: Align(alignment: elementAlignment, child: element));

  Widget _buildLabel(String label, context) => _wrapElement(Text(
        label,
        style: TextStyles.caption
            .copyWith(color: AppColors.of(context).neutralContent),
      ));

  List<Widget> _expandRow(LabeledTableRow row, BuildContext context) {
    return [
      Row(
        children: row.labels
            .map((label) => _buildLabel(label, context))
            .separate(const SizedBox(width: Insets.med))
            .toList(),
      ),
      const SizedBox(height: Insets.xs),
      Row(
        children: row.stats
            .map(_wrapElement)
            .separate(const SizedBox(width: Insets.med))
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

class LabeledTableRow {
  final List<String> labels;
  final List<Widget> stats;

  const LabeledTableRow({required this.labels, required this.stats})
      : assert(labels.length == stats.length,
            "The number of labels and stats in a row but be equal.");
}
