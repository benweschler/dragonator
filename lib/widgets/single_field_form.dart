import 'dart:async';

import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SingleFieldForm extends StatefulWidget {
  final ValueChanged<String> onSave;
  final String actionLabel;
  final String? initialValue;
  final int maxLength;

  const SingleFieldForm({
    super.key,
    required this.onSave,
    required this.actionLabel,
    this.initialValue,
    this.maxLength = 75,
  });

  @override
  State<SingleFieldForm> createState() => _SingleFieldFormState();
}

class _SingleFieldFormState extends State<SingleFieldForm> {
  late final _controller = TextEditingController(text: widget.initialValue);
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() async {
      await Future.delayed(Timings.med);
      _focusNode.requestFocus();
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    });
  }

  void _onSave(String value) {
    context.pop();
    widget.onSave(value);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              style: TextStyles.h1.copyWith(),
              focusNode: _focusNode,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxLength),
              ],
              onSubmitted: _onSave,
              decoration: InputDecoration(
                hintText: widget.initialValue,
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide()),
              ),
            ),
            SizedBox(height: 2 * Insets.xl),
            ExpandingStadiumButton(
              onTap: () => _onSave(_controller.value.text),
              color: AppColors.of(context).primary,
              label: widget.actionLabel,
            ),
          ],
        ),
      ),
    );
  }
}
