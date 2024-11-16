import 'dart:async';

import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SingleFieldFormScreen extends StatefulWidget {
  final ValueChanged<String> onSave;
  final String heading;
  final String? hintText;
  final String? initialValue;
  final int maxLength;

  const SingleFieldFormScreen({
    super.key,
    required this.onSave,
    required this.heading,
    this.hintText,
    this.initialValue,
    this.maxLength = 75,
  });

  @override
  State<SingleFieldFormScreen> createState() => _SingleFieldFormScreenState();
}

class _SingleFieldFormScreenState extends State<SingleFieldFormScreen> {
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      addScreenInset: false,
      leading: CustomIconButton(onTap: context.pop, icon: Icons.close_rounded),
      center: Text(widget.heading, style: TextStyles.title1),
      trailing: CustomIconButton(
        onTap: () {
          context.pop();
          widget.onSave(_controller.value.text);
        },
        icon: Icons.check_rounded,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
          child: TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            style: TextStyles.h1.copyWith(),
            focusNode: _focusNode,
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.maxLength),
            ],
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide()),
            ),
          ),
        ),
      ),
    );
  }
}
